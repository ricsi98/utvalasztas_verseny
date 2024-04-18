#include <curand_kernel.h>
__device__ int numOfDistance(int n, int d) {
    const int diameter = (n-1) / 2;
    if (d == 0) {
        return 1;
    }
    if (d <= diameter) {
        return 4 * d;
    }
    else {
        int z = 2*diameter - d + 1;
        return 4 * z;
    }
}

__device__ int2 distanceIndex2Offset(int distance, int index, int n) {
    const int num = numOfDistance(n*2+1, distance);
    const int fieldsPerSide = num / 4;
    const int fieldIdx = index / fieldsPerSide;
    const int remainder = index % fieldsPerSide;

    const int minX = max(1, distance - n);
    const int dx = minX + remainder;
    const int dy = distance - dx;

    if (fieldIdx == 0) {
        return make_int2(dx, dy);
    }
    if (fieldIdx == 1) {
        return make_int2(dy, -dx);
    }
    if (fieldIdx == 2) {
        return make_int2(-dx, -dy);
    }
    if (fieldIdx  == 3) {
        return make_int2(-dy, dx);
    }
}

__device__ int sampleAlias(curandState* state, int* alias, float* threshold, int n) {
    int offset = curand(state) % n;
    float alpha = curand_uniform(state);

    if (threshold[offset] < alpha) {
        return alias[offset];
    } else {
        return offset;
    }
}

__device__ int2 sampleOffsetNaive(curandState* state, int* alias, float* threshold, int n) {
    const int distance = sampleAlias(state, alias, threshold, n);
    const int num = numOfDistance(n, distance);
    const int index = curand(state) % num;
    return distanceIndex2Offset(distance, index, n);
}

__device__ int2 sampleOffset(curandState* state, int2 current, int* alias, float* threshold, int n) {
    while (true) {
        int2 offset = sampleOffsetNaive(state, alias, threshold, n);
        int x = offset.x + current.x;
        int y = offset.y + current.y;
        if (0 <= x && x < n && 0 <= y && y < n) {
            return make_int2(x,y);
        }
    }
}

extern "C" __global__
void my_fn(int* alias, float* threshold, int* y, int n, int cx, int cy) {
    int tid = blockDim.x * blockIdx.x + threadIdx.x;
    curandState state;
    curand_init(0, tid, 0, &state);
    int2 current = make_int2(cx, cy);
    int2 offset = sampleOffset(&state, current, alias, threshold, n);
    y[tid*2] = offset.x;
    y[tid*2+1] = offset.y;
}