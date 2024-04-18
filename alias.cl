#include <pyopencl-random123/philox.cl>
#include <pyopencl-random123/threefry.cl>

uint RAND_OFFSET = 0;

uint randint(uint index) {
    philox4x32_ctr_t c={{}};
    philox4x32_ukey_t uk={{}};

    uk.v[0] = index + RAND_OFFSET;
    philox4x32_key_t k = philox4x32keyinit(uk);
    philox4x32_ctr_t r = philox4x32(c, k);
    RAND_OFFSET += r.v[1];
    return r.v[0];
}


__kernel void sample_alias(
    __global ulong *output,
    __global ulong *aliases, 
    __global float *thresholds
    ) {
    const uint index = get_global_id(0);
    uint offset = randint(index);
    uint rand_num = randint(index);
    float psi = (float)(rand_num % 1025) / 1024.0f;
    if (psi < thresholds[offset]) {
        output[index] = offset;
    } else {
        output[index] = aliases[offset];
    }
}