#ifndef __D4_H__
#define __D4_H__

namespace d4 {

struct vec3 {
	union {
		struct {
			float x;
			float y;
			float z;
		};
		float a[3];
	};
};

struct vec4 {
	union {
		struct {
			float x;
			float y;
			float z;
			float k;
		};
		float a[4];
	};
};

#define MAT4_ITEM(m,i,j)	(m->a[(i)*4+(j)])
struct mat4 {
	float a[16];
};

}

extern "C" {
	void print_mat4(const char* name, const d4::mat4* m);
	void print_vec4(const char* name, const d4::vec4* v);
	void vec4_dot_mat4(d4::vec4*, d4::mat4*, d4::vec4* result);
	void slow_vec4_dot_mat4(d4::vec4*, d4::mat4*, d4::vec4 * result);
	void mat4_dot_mat4(d4::mat4* left, d4::mat4 *right, d4::mat4 *result);
	void slow_mat4_dot_mat4(d4::mat4* left, d4::mat4 *right, d4::mat4 *result);
	void mat4_transverse_inplace(d4::mat4 *m);
	void mat4_transverse(d4::mat4 *a, d4::mat4 *result);
};

#endif

