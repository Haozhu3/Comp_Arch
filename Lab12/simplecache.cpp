#include "simplecache.h"

int SimpleCache::find(int index, int tag, int block_offset) {
  // read handout for implementation details
  auto & vec = _cache[index];
  for (size_t i = 0; i < vec.size(); i++) {
  	if (vec[i].valid() == 1 && vec[i].tag() == tag) {
  		return vec[i].get_byte(block_offset);
  	}
  }
   
  return 0xdeadbeef;
}

void SimpleCache::insert(int index, int tag, char data[]) {
  // read handout for implementation details
  // keep in mind what happens when you assign in in C++ (hint: Rule of Three)
  auto & vec = _cache[index];
  size_t i;
  for (i = 0; i < vec.size(); i++) {
  	if (vec[i].valid() == 0) break;
  }
  i = i == vec.size() ? 0 : i;
  vec[i].replace(tag, data);
  
}
