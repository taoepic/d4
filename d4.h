#ifndef __D4_H__
#define __D4_H__

#include <stdio.h>

namespace d4 {

template<int size>
struct vec_n {
	float a[size];
} __attribute__((aligned(16)));

using vec3 = vec_n<3>;
using vec4 = vec_n<4>;

template<int size>
struct mat_n {
	union {
		struct vec_n<size> r[size];
		float a[size * size];
	};
} __attribute__((aligned(16)));

using mat3 = mat_n<3>;
using mat4 = mat_n<4>;

#define MAT_ITEM(size,m,i,j)	(m->a[(i)*(size)+(j)])

template<int size>
void print_mat(const char* name, const mat_n<size>* m) {
	printf("%s\n", name);
	for (int i = 0; i < size; i++) {
		for (int j = 0; j < size; j++) 
			printf("%10.4f ", MAT_ITEM(size,m,i,j));
		printf("\n");
	}
	printf("\n");
}

template<int size>
void print_vec(const char* name, const vec_n<size>* m) {
	printf("%s\n", name);
	for (int i = 0; i < size; i++)
		printf("%10.4f ", m->a[i]);
	printf("\n");
}

} /* end of namespace d4 */

extern "C" {
	int has_avx();
	const d4::mat3* mat3_normal();
	const d4::mat4* mat4_normal();
	void vec4_dot_vec4(d4::vec4* v1, d4::vec4* v2, d4::vec4* result);
	void vec4_plus_vec4(d4::vec4* v1, d4::vec4* v2, d4::vec4* result);
	void vec3_dot_vec3(d4::vec3* v1, d4::vec3* v2, d4::vec3* result);
	void vec3_plus_vec3(d4::vec3* v1, d4::vec3* v2, d4::vec3* result);
	void vec4_multiply_mat4(d4::vec4*, d4::mat4*, d4::vec4* result);
	void slow_vec4_multiply_mat4(d4::vec4*, d4::mat4*, d4::vec4 * result);
	void mat4_multiply_mat4(d4::mat4* left, d4::mat4 *right, d4::mat4 *result);
	void slow_mat4_multiply_mat4(d4::mat4* left, d4::mat4 *right, d4::mat4 *result);
	void mat4_transverse_inplace(d4::mat4 *m);
	void mat4_transverse(d4::mat4 *a, d4::mat4 *result);
};

#endif

