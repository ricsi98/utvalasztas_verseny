#include <pyopencl-random123/philox.cl>
#include <pyopencl-random123/threefry.cl>

int RAND_OFFSET = 0;

float randint(int seed) {
    const uint index = get_global_id(0);
    philox4x32_ctr_t c={{}};
    philox4x32_ukey_t uk={{}};

    uk.v[0] = index+seed+RAND_OFFSET;
    RAND_OFFSET += 1;
    philox4x32_key_t k = philox4x32keyinit(uk);
    philox4x32_ctr_t r = philox4x32(c, k);
    return r.v[0];
}


__kernel void sample_alias(
    __global ulong *output, 
    __global ulong *aliases, 
    __global float16 *thresholds
    ) {
    const uint index = get_global_id(0);
    output[index] = randint(0);
}