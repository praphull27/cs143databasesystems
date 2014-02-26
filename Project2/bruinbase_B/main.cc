/**
 * Copyright (C) 2008 by The Regents of the University of California
 * Redistribution of this file is permitted under the terms of the GNU
 * Public License (GPL).
 *
 * @author Junghoo "John" Cho <cho AT cs.ucla.edu>
 * @date 3/24/2008
 */
 
#include "Bruinbase.h"
#include "BTreeNode.cc"
#include "SqlEngine.h"
#include "BTreeNode.h"
#include "PageFile.h"
#include "PageFile.cc"
#include "RecordFile.h"
#include "RecordFile.cc"
#include <iostream>


int main()
{
  // run the SQL engine taking user commands from standard input (console).
  //SqlEngine::run(stdin);
    
    BTLeafNode leaf, leaf_2;
    BTNonLeafNode nonleaf;
    PageFile pf;
    RC rc;
    PageId pid, pid_2;
    RecordId rid, rid_2;
    
    RecordFile rf;   // RecordFile containing the table
    
    int    key, key_2;
    std::string value, value_2;
    int    count;
    int    diff;
    
    // open the table file
    rc = rf.open("movie.tbl", 'r');
    
    rid.pid = rid.sid = 0;
    rc = rf.read(rid, key, value);
    
    rid_2.pid = 0; rid_2.sid = 1;
    rc = rf.read(rid_2, key_2, value_2);
    
    //std::cout<<key<<value;
    
    leaf.insert(key, rid);
    leaf_2.insert(key_2, rid_2);
    
    rc = pf.open("test", 'w');
    pid = pf.endPid();

    
    leaf.write(pid, pf);
    
    pid_2 = pf.endPid();
    leaf_2.write(pid_2, pf);
    pf.close();
    
    //rc = pf.open("test", 'r');
    //leaf.read(pid, pf);
    //pf.close();
    int eid;
    //leaf.locate(272, eid);
    int key1, key2;
    std::string value2;
    RecordId rid1;
    //leaf.readEntry(eid, key1, rid1);
    //std::cout<<eid<<"\n"<<key1<<"\n"<<rid1.pid<<"\n"<<rid1.sid<<"\n";
    
    //rf.read(rid1, key2, value2);
    //std::cout<<key2<<"\n"<<value2<<"\n";
    
    nonleaf.initializeRoot(pid, 2000, pid_2);
    
    rc = pf.open("test", 'w');
    pid = pf.endPid();
    
    nonleaf.write(pid, pf);
    pf.close();
    
    rc = pf.open("test", 'r');
    nonleaf.read(pid, pf);
    PageId pid_out;
    nonleaf.locateChildPtr(2000, pid_out);
    leaf.read(pid_out, pf);
    leaf.locate(272, eid);
    leaf.readEntry(eid, key1, rid1);
    rf.read(rid1, key2, value2);
    std::cout<<key2<<"\n"<<value2<<"\n";
    return 0;
}
