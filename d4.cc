#include <iostream>
#include "d4.h"

using namespace d4;

void slow_mat4_multiply_mat4(mat4* u, mat4* v, mat4 *c) {
	for (int i = 0; i < 4; i++) {
		for (int j = 0; j < 4; j++) {
			MAT_ITEM(4,c,i,j) = MAT_ITEM(4,u,i,0) * MAT_ITEM(4,v,0,j) +
					MAT_ITEM(4,u,i,1) * MAT_ITEM(4,v,1,j) +
					MAT_ITEM(4,u,i,2) * MAT_ITEM(4,v,2,j) +
					MAT_ITEM(4,u,i,3) * MAT_ITEM(4,v,3,j);
		}
	}
}

#define DOT_MAT4_PROD(u,m,col)	\
		(u->a[0]*MAT_ITEM(4,m,0,col) + u->a[1]*MAT_ITEM(4,m,1,col) \
		+ u->a[2]*MAT_ITEM(4,m,2,col) + u->a[3]*MAT_ITEM(4,m,3,col))

void slow_vec4_multiply_mat4(vec4* u, mat4 *m, vec4* v){
	for (int i = 0; i < 4; i++) 
		v->a[i] = DOT_MAT4_PROD(u, m, i);
}


