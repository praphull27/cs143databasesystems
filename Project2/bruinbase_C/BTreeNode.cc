#include "BTreeNode.h"
#include <cmath>

using namespace std;
static const int nonLeafNodeKeys = floor((PageFile::PAGE_SIZE - sizeof(int) - sizeof(PageId))/(sizeof(int) + sizeof(PageId))) - 1;
static const int minNonLeafNodeKeys = ceil((nonLeafNodeKeys + 1) / 2) - 1;
static const int leafNodeKeys = floor((PageFile::PAGE_SIZE - sizeof(int) - sizeof(PageId))/(sizeof(int) + sizeof(RecordId))) - 1;
static const int minLeafNodeKeys = ceil(leafNodeKeys / 2);
static const int intBufferSize = PageFile::PAGE_SIZE/sizeof(int);

/*
 *Constructor to initialize the Leaf Node. It will assign -1 to all elements in the buffer.
*/
BTLeafNode::BTLeafNode()
{
	for(int i=0; i<intBufferSize; i++)
	{
		buffer.buffer_int[i] = -1;
	}
}

/*
 * Read the content of the node from the page pid in the PageFile pf.
 * @param pid[IN] the PageId to read
 * @param pf[IN] PageFile to read from
 * @return 0 if successful. Return an error code if there is an error.
 */
RC BTLeafNode::read(PageId pid, const PageFile& pf)
{
	return pf.read(pid, buffer.buffer_char);
}
    
/*
 * Write the content of the node to the page pid in the PageFile pf.
 * @param pid[IN] the PageId to write to
 * @param pf[IN] PageFile to write to
 * @return 0 if successful. Return an error code if there is an error.
 */
RC BTLeafNode::write(PageId pid, PageFile& pf)
{
	return pf.write(pid, buffer.buffer_char);
}

/*
 * Return the number of keys stored in the node.
 * @return the number of keys in the node
 * Count is stored in the first element of the integer buffer.
 */
int BTLeafNode::getKeyCount()
{
	if(buffer.buffer_int[0] != -1)
	{
		return buffer.buffer_int[0];
	}
	else
	{
		return 0;
	}
}

/*
 * Insert a (key, rid) pair to the node.
 * @param key[IN] the key to insert
 * @param rid[IN] the RecordId to insert
 * @return 0 if successful. Return an error code if the node is full.
 * Leaf-Node:
 * 1st Element contains number of keys.
 * then pair of (rid,key) is stored.
 * Last element points to th next leaf node.
 * There is an extra space to take care of split case (overflow case).
 */
RC BTLeafNode::insert(int key, const RecordId& rid)
{
	int count, i=3;
	count = getKeyCount();

	//If node is full return error.
	if(count == leafNodeKeys) {
		return RC_NODE_FULL;
	}

	//Check for first largest key.
	for (i=3; i<=count*3; i=i+3)
	{
		if(buffer.buffer_int[i] > key)
			break;
	}

	//Shift all the elements greater than the key
	for (int j=count*3;j>=i-2; j--)
	{
		buffer.buffer_int[j+3] = buffer.buffer_int[j];
	}
	//Insert the new (rid,key) pair
	buffer.buffer_int[i] = key;
	buffer.buffer_int[i-2] = (int) rid.pid;
	buffer.buffer_int[i-1] = (int) rid.sid;
	//Increasing the count by one.
	buffer.buffer_int[0] = count+1;
	return 0;
}

/*
 * Insert the (key, rid) pair to the node
 * and split the node half and half with sibling.
 * The first key of the sibling node is returned in siblingKey.
 * @param key[IN] the key to insert.
 * @param rid[IN] the RecordId to insert.
 * @param sibling[IN] the sibling node to split with. This node MUST be EMPTY when this function is called.
 * @param siblingKey[OUT] the first key in the sibling node after split.
 * @return 0 if successful. Return an error code if there is an error.
 * Leaf-Node:
 * 1st Element contains number of keys.
 * then pair of (rid,key) is stored.
 * Last element points to th next leaf node.
 * There is an extra space to take care of split case (overflow case).
 */
RC BTLeafNode::insertAndSplit(int key, const RecordId& rid, 
                              BTLeafNode& sibling, int& siblingKey)
{
	int count, i;
	count = getKeyCount();

	//Check for first largest key.
	for (i=3; i<=count*3; i=i+3)
	{
		if(buffer.buffer_int[i] > key)
			break;
	}

	//Shift all the elements greater than the key
	for (int j=count*3;j>=i-2; j--)
	{
		buffer.buffer_int[j+3] = buffer.buffer_int[j];
	}
	//Insert the new (rid,key) pair
	buffer.buffer_int[i] = key;
	buffer.buffer_int[i-2] = (int) rid.pid;
	buffer.buffer_int[i-1] = (int) rid.sid;
	buffer.buffer_int[0] = count+1;

	//Moving the right half of the node to the sibling node.
	for (i=minLeafNodeKeys*3+6; i<intBufferSize-1; i = i+3) {
		RecordId temp_rid;
		temp_rid.pid = buffer.buffer_int[i-2];
		temp_rid.sid = buffer.buffer_int[i-1];
		sibling.insert(buffer.buffer_int[i], temp_rid);
	}
	//Setting the next pointer of the sibling node.
	PageId next = (PageId) buffer.buffer_int[intBufferSize-1];
	sibling.setNextNodePtr(next);

	//Getting the first key of the sibling node.
	siblingKey = buffer.buffer_int[minLeafNodeKeys*3+6];

	//Removing the moved values from the current node by seeting the array elements to -1
	for (i=minLeafNodeKeys*3+4; i<intBufferSize-1; i++) {
		buffer.buffer_int[i] = -1;
	}
	buffer.buffer_int[0] = minLeafNodeKeys+1;
	//buffer.buffer_int[intBufferSize-1] = 
	return 0;
}

/*
 * Find the entry whose key value is larger than or equal to searchKey
 * and output the eid (entry number) whose key value >= searchKey.
 * Remeber that all keys inside a B+tree node should be kept sorted.
 * @param searchKey[IN] the key to search for
 * @param eid[OUT] the entry number that contains a key larger than or equalty to searchKey
 * @return 0 if successful. Return an error code if there is an error.
 */
RC BTLeafNode::locate(int searchKey, int& eid)
{
	int count;
	count = getKeyCount();
	int flag = 0, i;

	//Check for first equal or largest key.
	for (i=3; i<=count*3; i=i+3)
	{
		if(buffer.buffer_int[i] >= searchKey) {
			flag = 1;
			break;
		}
	}

	if(flag == 0) {
		return RC_NO_SUCH_RECORD;
	} else {
		//eid is divided by 3 to get nth value of (rid, key) pair.
		eid = i/3;
	}
	return 0;
}

/*
 * Read the (key, rid) pair from the eid entry.
 * @param eid[IN] the entry number to read the (key, rid) pair from
 * @param key[OUT] the key from the entry
 * @param rid[OUT] the RecordId from the entry
 * @return 0 if successful. Return an error code if there is an error.
 */
RC BTLeafNode::readEntry(int eid, int& key, RecordId& rid)
{
	if (eid < 0 || eid > getKeyCount()){
		return RC_INVALID_CURSOR;
	}

	//eid is multiplied by 3 to get the array index.
	rid.pid = buffer.buffer_int[eid*3-2];
	rid.sid = buffer.buffer_int[eid*3-1];
	key = buffer.buffer_int[eid*3];

	return 0;
}

/*
 * Return the pid of the next slibling node.
 * @return the PageId of the next sibling node 
 */
PageId BTLeafNode::getNextNodePtr()
{
	PageId p = (PageId) buffer.buffer_int[intBufferSize-1];
	return p;
}

/*
 * Set the pid of the next slibling node.
 * @param pid[IN] the PageId of the next sibling node 
 * @return 0 if successful. Return an error code if there is an error.
 */
RC BTLeafNode::setNextNodePtr(PageId pid)
{
	if((int) pid < -1) {
		return RC_INVALID_PID;
	}
	buffer.buffer_int[intBufferSize-1] = (int) pid;
	return 0;
}

/*
 *Constructor to initialize the Non-Leaf Node. It will assign -1 to all elements in the buffer.
*/
BTNonLeafNode::BTNonLeafNode()
{
	for(int i=0; i<intBufferSize; i++)
	{
		buffer.buffer_int[i] = -1;
	}
}

/*
 * Read the content of the node from the page pid in the PageFile pf.
 * @param pid[IN] the PageId to read
 * @param pf[IN] PageFile to read from
 * @return 0 if successful. Return an error code if there is an error.
 */
RC BTNonLeafNode::read(PageId pid, const PageFile& pf)
{
	return pf.read(pid, buffer.buffer_char);
}
    
/*
 * Write the content of the node to the page pid in the PageFile pf.
 * @param pid[IN] the PageId to write to
 * @param pf[IN] PageFile to write to
 * @return 0 if successful. Return an error code if there is an error.
 */
RC BTNonLeafNode::write(PageId pid, PageFile& pf)
{
	return pf.write(pid, buffer.buffer_char);
}

/*
 * Return the number of keys stored in the node.
 * @return the number of keys in the node
 * Count is stored in the first element of the integer buffer.
 */
int BTNonLeafNode::getKeyCount()
{
	if(buffer.buffer_int[0] != -1)
	{
		return buffer.buffer_int[0];
	}
	else
	{
		return 0;
	}
}

/*
 * Insert a (key, pid) pair to the node.
 * @param key[IN] the key to insert
 * @param pid[IN] the PageId to insert
 * @return 0 if successful. Return an error code if the node is full.
 * Non-Leaf-Node:
 * 1st Element contains number of keys.
 * then a page id to left most sub node.
 * then pairs of (key,page id).
 * There is an extra space to take care of split case (overflow case).
 */
RC BTNonLeafNode::insert(int key, PageId pid)
{
	int count, i;
	count = getKeyCount();

	//If node is full return error.
	if(count == nonLeafNodeKeys) {
		return RC_NODE_FULL;
	}

	//Check for first largest key.
	for (i=2; i<=count*2; i=i+2)
	{
		if(buffer.buffer_int[i] > key)
			break;
	}

	//Shift all keys greater than new key.
	for (int j=count*2+1;j>=i; j--)
	{
		buffer.buffer_int[j+2] = buffer.buffer_int[j];
	}
	buffer.buffer_int[i] = key;
	buffer.buffer_int[i+1] = (int) pid;
	buffer.buffer_int[0] = count+1;
	return 0;
}

/*
 * Insert the (key, pid) pair to the node
 * and split the node half and half with sibling.
 * The middle key after the split is returned in midKey.
 * @param key[IN] the key to insert
 * @param pid[IN] the PageId to insert
 * @param sibling[IN] the sibling node to split with. This node MUST be empty when this function is called.
 * @param midKey[OUT] the key in the middle after the split. This key should be inserted to the parent node.
 * @return 0 if successful. Return an error code if there is an error.
 */
RC BTNonLeafNode::insertAndSplit(int key, PageId pid, BTNonLeafNode& sibling, int& midKey)
{
	int count, i;
	count = getKeyCount();

	//Check for first largest key.
	for (i=2; i<=count*2; i=i+2)
	{
		if(buffer.buffer_int[i] > key)
			break;
	}

	//Shift all keys greater than new key.
	for (int j=count*2+1;j>=i; j--)
	{
		buffer.buffer_int[j+2] = buffer.buffer_int[j];
	}
	buffer.buffer_int[i] = key;
	buffer.buffer_int[i+1] = (int) pid;
	buffer.buffer_int[0] = count+1;

	//Initializing the new sibling non-leaf node.
	PageId p1 = (PageId) buffer.buffer_int[minNonLeafNodeKeys*2+3];
	PageId p2 = (PageId) buffer.buffer_int[minNonLeafNodeKeys*2+5];

	sibling.initializeRoot(p1, buffer.buffer_int[minNonLeafNodeKeys*2+4], p2);

	//Copying the right half to the sibling node.
	for (i=minNonLeafNodeKeys*2+6; i<intBufferSize; i = i+2) {
		PageId p = (PageId) buffer.buffer_int[i+1];
		sibling.insert(buffer.buffer_int[i], p);
	}

	//Setting the mid key variable.
	midKey = buffer.buffer_int[minNonLeafNodeKeys*2+2];

	//Setting the right half of the current buffer to -1
	for (i=minNonLeafNodeKeys*2+2; i<intBufferSize; i++) {
		buffer.buffer_int[i] = -1;
	}
	buffer.buffer_int[0] = minNonLeafNodeKeys;
	return 0;
}

/*
 * Given the searchKey, find the child-node pointer to follow and
 * output it in pid.
 * @param searchKey[IN] the searchKey that is being looked up.
 * @param pid[OUT] the pointer to the child node to follow.
 * @return 0 if successful. Return an error code if there is an error.
 */
RC BTNonLeafNode::locateChildPtr(int searchKey, PageId& pid)
{
	int count;
	count = getKeyCount();
	if(count == 0) {
		return RC_NO_SUCH_RECORD;
	}
	int flag = 0, i;
	for (i=2; i<=count*2; i=i+2)
	{
		if(buffer.buffer_int[i] > searchKey){
			flag = 1;
			break;
		}
			
	}
	PageId p;
	if(flag == 0) {
		p = (PageId) buffer.buffer_int[count*2+1];
	} else {
		p = (PageId) buffer.buffer_int[i-1];
	}

	pid = p;
	return 0;
}

/*
 * Initialize the root node with (pid1, key, pid2).
 * @param pid1[IN] the first PageId to insert
 * @param key[IN] the key that should be inserted between the two PageIds
 * @param pid2[IN] the PageId to insert behind the key
 * @return 0 if successful. Return an error code if there is an error.
 */
RC BTNonLeafNode::initializeRoot(PageId pid1, int key, PageId pid2)
{
	for(int i=0; i<256; i++)
	{
		buffer.buffer_int[i] = -1;
	}

	buffer.buffer_int[0] = 1;
	buffer.buffer_int[1] = (int) pid1;
	buffer.buffer_int[2] = key;
	buffer.buffer_int[3] = (int) pid2;
	return 0;
}
