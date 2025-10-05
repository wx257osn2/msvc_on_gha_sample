#ifdef __AVX2__
#include<immintrin.h>
#elifdef __aarch64__
#include<arm_neon.h>
#endif

constexpr bool constant_evaluated() {
	if consteval {
		return true;
	}
	else {
		return false;
	}
}

#include<cassert>
#include<print>
#include<array>
#include<cstdint>
int main() {
	static_assert(constant_evaluated());
	assert(!constant_evaluated());
#ifdef __AVX2__
	std::print("AVX2 enabled:");
	const std::array<std::uint32_t, 8> as = {0, 1, 2, 3, 4, 5, 6, 7};
	const std::array<std::uint32_t, 8> bs = {0, 10, 20, 30, 40, 50, 60, 70};
	const auto a = _mm256_loadu_si256(reinterpret_cast<const __m256i*>(as.data()));
	const auto b = _mm256_loadu_si256(reinterpret_cast<const __m256i*>(bs.data()));
	const auto c = _mm256_add_epi32(a, b);
	std::array<std::uint32_t, 8> cs;
	_mm256_storeu_si256(reinterpret_cast<__m256i*>(cs.data()), c);
	for (const auto x : cs)
		std::print("{}, ", x);
	std::println("");
#elifdef __aarch64__
	std::print("ASIMD enabled:");
	const std::array<std::uint32_t, 4> as = {0, 1, 2, 3};
	const std::array<std::uint32_t, 4> bs = {0, 10, 20, 30};
	const auto a = vld1q_u32(as.data());
	const auto b = vld1q_u32(bs.data());
	const auto c = vaddq_u32(a, b);
	std::array<std::uint32_t, 4> cs;
	vst1q_u32(cs.data(), c);
	for (const auto x : cs)
		std::print("{}, ", x);
	std::println("");
#endif
}