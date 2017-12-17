#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
	auto tag_size = cache_config.get_num_tag_bits();
	if (tag_size == 0) return 0;
	return address >> (32 - tag_size);
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
	auto tag_size = cache_config.get_num_tag_bits();
	auto off_size = cache_config.get_num_block_offset_bits();
	if (cache_config.get_num_index_bits() == 0) return 0;
	return (address << tag_size) >> tag_size >> off_size;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  	auto off_size = cache_config.get_num_block_offset_bits();
  	if (off_size == 0) return 0;
  	return address << (32 - off_size) >> (32 - off_size);
}
