#include <pyopencl-random123/philox.cl>
#include <pyopencl-random123/threefry.cl>

__kernel void generate_random_numbers(__global ulong *output, uint seed) {
    const uint index = get_global_id(0);
    philox4x32_ctr_t c={{}};
    philox4x32_ukey_t uk={{}};

    uk.v[0] = index+1233213;
    philox4x32_key_t k = philox4x32keyinit(uk);
    philox4x32_ctr_t r = philox4x32(c, k);
    output[index] = r.v[0];
}