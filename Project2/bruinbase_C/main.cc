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
#include "BTreeIndex.h"
#include "BTreeIndex.cc"
#include <iostream>

using namespace std;

int main()
{
  // run the SQL engine taking user commands from standard input (console).
  //SqlEngine::run(stdin);
    
    BTreeIndex treeIndex;
    RecordFile rf;
    RC rc;
    RecordId rid;
    int    key;
    string value;
    treeIndex.open("test.index", 'w');
    
    rc = rf.open("movie.tbl", 'r');
    rid.pid = rid.sid = 0;
    for (int i = 1; i <= 5; i++){
        rf.read(rid, key, value);
        treeIndex.insert(key, rid);
        cout<<"Key :"<<key<<" Value : "<<value<<"\n";
        rid++;
    }
    
    treeIndex.close();
    cout<<"Output:"<<"\n";
    treeIndex.open("test.index", 'r');
    IndexCursor cursor;
    key = 252;
    treeIndex.locate(key, cursor);
    rc = 0;
    while (rc != RC_END_OF_TREE) {
        rc = treeIndex.readForward(cursor, key, rid);
        rf.read(rid, key, value);
        cout<<"Key :"<<key<<" Value : "<<value<<"\n";
    }
    //treeIndex.readForward(cursor, key, rid);



  return 0;
}
