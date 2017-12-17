#include "cacheblock.h"
#include <iostream>
#include <cmath>

uint32_t Cache::Block::get_address() const {
	auto tag_size = _cache_config.get_num_tag_bits();
	auto idx_size = _cache_config.get_num_index_bits();
	auto off_size = 32 - tag_size - idx_size;
	if (tag_size == 32) return _tag;
	return (_tag << (idx_size + off_size)) + (_index << off_size);
}
