#include <iostream>
#include "d4.h"

using namespace d4;

#define MAT_ITEM(m,i,j)		(m->a[(i)*4+(j)])
void slow_mat4_dot_mat4(mat4* u, mat4* v, mat4 *c) {
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4; j++) {
			MAT_ITEM(c,i,j) = MAT_ITEM(u,i,0) * MAT_ITEM(v,0,j) +
					MAT_ITEM(u,i,1) * MAT_ITEM(v,1,j) +
					MAT_ITEM(u,i,2) * MAT_ITEM(v,2,j) +
					MAT_ITEM(u,i,3) * MAT_ITEM(v,3,j);
		}
	}
}

#define DOT_MAT_PROD(u,m,col)	\
	(u->x*MAT_ITEM(m,0,col) + u->y*MAT_ITEM(m,1,col) + u->z*MAT_ITEM(m,2,col) + u->k*MAT_ITEM(m,3,col))
void slow_vec4_dot_mat4(vec4* u, mat4 *m, vec4* v){
	v->x = DOT_MAT_PROD(u, m, 0);
	v->y = DOT_MAT_PROD(u, m, 1);
	v->z = DOT_MAT_PROD(u, m, 2);
	v->k = DOT_MAT_PROD(u, m, 3);
}

void print_mat4(const char* name, const mat4* m) {
	printf("MAT4: %s\n", name);
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4; j++) {
			printf("%10.4f ", MAT_ITEM(m,i,j));
		}
		printf ("\n");
	}
	printf("\n");
}

void print_vec4(const char* name, const vec4* v) {
	printf("VEC4: %s\n", name);
	for (int i = 0; i < 4; i++) {
		printf("%10.4f ", v->a[i]);
	}
	printf("\n");
}


