/**
 * Copyright (C) 2008 by The Regents of the University of California
 * Redistribution of this file is permitted under the terms of the GNU
 * Public License (GPL).
 *
 * @author Junghoo "John" Cho <cho AT cs.ucla.edu>
 * @date 3/24/2008
 */

#include <cstdio>
#include <iostream>
#include <fstream>
#include "Bruinbase.h"
#include "SqlEngine.h"
#include "BTreeIndex.h"

using namespace std;

// external functions and variables for load file and sql command parsing
extern FILE* sqlin;
int sqlparse(void);


RC SqlEngine::run(FILE* commandline)
{
    fprintf(stdout, "Bruinbase> ");
    
    // set the command line input and start parsing user input
    sqlin = commandline;
    sqlparse();  // sqlparse() is defined in SqlParser.tab.c generated from
    // SqlParser.y by bison (bison is GNU equivalent of yacc)
    
    return 0;
}

RC SqlEngine::select(int attr, const string& table, const vector<SelCond>& cond)
{
    RecordFile rf;   // RecordFile containing the table
    RecordId   rid;  // record cursor for table scanning
    BTreeIndex treeIndex;
    
    RC     rc;
    int    key = 0;
    string value;
    int    count;
    int    diff;
    bool index = true;
    int keyCount = 0;
    IndexCursor cursor;
    int notEqualKeys[cond.size()];
    int equals = -1, min = 0, max = RC_END_OF_TREE;

    // open the table file
    if ((rc = rf.open(table + ".tbl", 'r')) < 0) {
        fprintf(stderr, "Error: table %s does not exist\n", table.c_str());
        return rc;
    }
    
    if (treeIndex.open(table + ".idx", 'r') < 0) {
        index = false;
    }
    
    for (unsigned i = 0; i < cond.size(); i++) {
        if (cond[i].attr == 1) {
            keyCount++;
            notEqualKeys[i] = -1;
            switch (cond[i].comp) {
                case SelCond::EQ:
                    if (equals != -1 && equals != atoi(cond[i].value)) {
                        goto exit_select;
                    } else {
                        equals = atoi(cond[i].value);
                    }
                    break;
                case SelCond::NE:
                    notEqualKeys[i] = atoi(cond[i].value);
                    keyCount--;
                    break;
                case SelCond::GT:
                    if (atoi(cond[i].value) > min) {
                        min = atoi(cond[i].value) + 1;
                    }
                    break;
                case SelCond::LT:
                    if (atoi(cond[i].value) < max) {
                        max = atoi(cond[i].value) - 1;
                    } else if (max == RC_END_OF_TREE) {
                        max = atoi(cond[i].value) - 1;
                    }
                    break;
                case SelCond::GE:
                    if (atoi(cond[i].value) > min) {
                        min = atoi(cond[i].value);
                    }
                    break;
                case SelCond::LE:
                    if (atoi(cond[i].value) < max) {
                        max = atoi(cond[i].value);
                    } else if (max == RC_END_OF_TREE) {
                        max = atoi(cond[i].value);
                    }
                    break;
            }
        }
    }
    
    if (max != RC_END_OF_TREE && (max < min || (equals != -1 && (equals < min || equals > max)))){
        goto exit_select;
    }
    
    if (keyCount == 0) {
        index = false;
    }
    
    count = 0;
    
    if (index) {
        if (equals != -1) {
            rc = treeIndex.locate(equals, cursor);
            if (rc == RC_NO_SUCH_RECORD) {
                goto exit_select;
            }
            rc = treeIndex.readForward(cursor, key, rid);
            diff = key - equals;
            if (diff == 0) {
                for (unsigned i = 0; i < cond.size(); i++) {
                    if (cond[i].attr == 1 && cond[i].comp == SelCond::NE) {
                        if (equals == atoi(cond[i].value)) {
                            goto exit_select;
                        }
                    } else if (cond[i].attr == 2) {
                        rf.read(rid, key, value);
                        diff = strcmp(value.c_str(), cond[i].value);
                        switch (cond[i].comp) {
                            case SelCond::EQ:
                                if (diff != 0) goto exit_select;
                                break;
                            case SelCond::NE:
                                if (diff == 0) goto exit_select;
                                break;
                            case SelCond::GT:
                                if (diff <= 0) goto exit_select;
                                break;
                            case SelCond::LT:
                                if (diff >= 0) goto exit_select;
                                break;
                            case SelCond::GE:
                                if (diff < 0) goto exit_select;
                                break;
                            case SelCond::LE:
                                if (diff > 0) goto exit_select;
                                break;
                        }
                    }
                }
                count++;
                switch (attr) {
                    case 1:  // SELECT key
                        fprintf(stdout, "%d\n", key);
                        break;
                    case 2:  // SELECT value
                        rf.read(rid, key, value);
                        fprintf(stdout, "%s\n", value.c_str());
                        break;
                    case 3:  // SELECT *
                        rf.read(rid, key, value);
                        fprintf(stdout, "%d '%s'\n", key, value.c_str());
                        break;
                }
                goto exit_select;
            } else {
                goto exit_select;
            }
        }
        
        int j = min;
        
        rc = treeIndex.locate(j, cursor);
        if (rc == RC_NO_SUCH_RECORD) {
            goto exit_select;
        }
        rc = treeIndex.readForward(cursor, key, rid);
        bool temp = false;
        
        if (rc == RC_END_OF_TREE && temp == false) {
            temp = true;
        }
        j = key;
        bool check = true;
        if (max != RC_END_OF_TREE) {
            if (j > max) {
                check = false;
            }
        }
        while (check) {
            
            for (unsigned i = 0; i < cond.size(); i++) {
                
                if (cond[i].attr == 1 && cond[i].comp == SelCond::NE) {
                    if (j == atoi(cond[i].value)) {
                        goto while_end;
                    }
                } else if (cond[i].attr == 2) {
                    rf.read(rid, key, value);
                    diff = strcmp(value.c_str(), cond[i].value);
                    switch (cond[i].comp) {
                        case SelCond::EQ:
                            if (diff != 0) goto while_end;
                            break;
                        case SelCond::NE:
                            if (diff == 0) goto while_end;
                            break;
                        case SelCond::GT:
                            if (diff <= 0) goto while_end;
                            break;
                        case SelCond::LT:
                            if (diff >= 0) goto while_end;
                            break;
                        case SelCond::GE:
                            if (diff < 0) goto while_end;
                            break;
                        case SelCond::LE:
                            if (diff > 0) goto while_end;
                            break;
                    }
                }
            }
            count++;
            switch (attr) {
                case 1:  // SELECT key
                    fprintf(stdout, "%d\n", key);
                    break;
                case 2:  // SELECT value
                    rf.read(rid, key, value);
                    fprintf(stdout, "%s\n", value.c_str());
                    break;
                case 3:  // SELECT *
                    rf.read(rid, key, value);
                    fprintf(stdout, "%d '%s'\n", key, value.c_str());
                    break;
            }

        while_end:
            rc = treeIndex.readForward(cursor, key, rid);
            j = key;
            if (rc == RC_END_OF_TREE && temp == false) {
                temp = true;
            } else if (rc == RC_END_OF_TREE) {
                goto exit_select;
            }
            if (max != RC_END_OF_TREE && j > max) {
                check = false;
            }
        }
        goto exit_select;
    }
    
    
    // scan the table file from the beginning
    rid.pid = rid.sid = 0;
    count = 0;
    while (rid < rf.endRid()) {
        // read the tuple
        if ((rc = rf.read(rid, key, value)) < 0) {
            fprintf(stderr, "Error: while reading a tuple from table %s\n", table.c_str());
            goto exit_select;
        }
        
        // check the conditions on the tuple
        for (unsigned i = 0; i < cond.size(); i++) {
            // compute the difference between the tuple value and the condition value
            switch (cond[i].attr) {
                case 1:
                    diff = key - atoi(cond[i].value);
                    break;
                case 2:
                    diff = strcmp(value.c_str(), cond[i].value);
                    break;
            }
            
            // skip the tuple if any condition is not met
            switch (cond[i].comp) {
                case SelCond::EQ:
                    if (diff != 0) goto next_tuple;
                    break;
                case SelCond::NE:
                    if (diff == 0) goto next_tuple;
                    break;
                case SelCond::GT:
                    if (diff <= 0) goto next_tuple;
                    break;
                case SelCond::LT:
                    if (diff >= 0) goto next_tuple;
                    break;
                case SelCond::GE:
                    if (diff < 0) goto next_tuple;
                    break;
                case SelCond::LE:
                    if (diff > 0) goto next_tuple;
                    break;
            }
        }
        
        // the condition is met for the tuple.
        // increase matching tuple counter
        count++;
        
        // print the tuple
        switch (attr) {
            case 1:  // SELECT key
                fprintf(stdout, "%d\n", key);
                break;
            case 2:  // SELECT value
                fprintf(stdout, "%s\n", value.c_str());
                break;
            case 3:  // SELECT *
                fprintf(stdout, "%d '%s'\n", key, value.c_str());
                break;
        }
        
        // move to the next tuple
    next_tuple:
        ++rid;
    }
    
    // close the table file and return
exit_select:
    if (attr == 4) {
        fprintf(stdout, "%d\n", count);
    }
    rc = 0;

    rf.close();
    if (index) {
        treeIndex.close();
    }
    return rc;
}

RC SqlEngine::load(const string& table, const string& loadfile, bool index)
{
    RecordFile rf;   // RecordFile containing the table
    RecordId   rid;  // record cursor for table scanning
    BTreeIndex treeIndex;
    RC     rc;
    int    key;
    string value;
    string line;
    
    //Opening the loadfile in read mode.
    ifstream infile(loadfile.c_str());
    
    //Opening the table.tbl (Record File) file in write mode. If the file is not present, it will create a new file.
    if ((rc = rf.open(table + ".tbl", 'w')) < 0) {
        fprintf(stderr, "Error: Not able to create table %s\n", table.c_str());
        return rc;
    }
    
    //Initializing rid with the end record id of the record file
    rid = rf.endRid();
    
    if (index) {
        treeIndex.open(table + ".idx", 'w');
    }
    
    //Reading loadfile line by line and wrting the parsed key value pairs in the record file
    while (getline(infile, line)) {
        parseLoadLine(line, key, value);
        rf.append(key, value, rid);
        if (index) {
            treeIndex.insert(key, rid);
        }
        rid++;
    }
    
    rf.close();
    treeIndex.close();
    
    infile.close();
    
    return 0;
}

RC SqlEngine::parseLoadLine(const string& line, int& key, string& value)
{
    const char *s;
    char        c;
    string::size_type loc;
    
    // ignore beginning white spaces
    c = *(s = line.c_str());
    while (c == ' ' || c == '\t') { c = *++s; }
    
    // get the integer key value
    key = atoi(s);
    
    // look for comma
    s = strchr(s, ',');
    if (s == NULL) { return RC_INVALID_FILE_FORMAT; }
    
    // ignore white spaces
    do { c = *++s; } while (c == ' ' || c == '\t');
    
    // if there is nothing left, set the value to empty string
    if (c == 0) { 
        value.erase();
        return 0;
    }
    
    // is the value field delimited by ' or "?
    if (c == '\'' || c == '"') {
        s++;
    } else {
        c = '\n';
    }
    
    // get the value string
    value.assign(s);
    loc = value.find(c, 0);
    if (loc != string::npos) { value.erase(loc); }
    
    return 0;
}
