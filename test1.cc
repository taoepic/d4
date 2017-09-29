#include <iostream>
#include <unistd.h>
#include <time.h>
#include "d4.h"

using namespace d4;
pid_t pid;
clockid_t clock_id;

main() {
	pid = getpid();
	clock_getcpuclockid(pid, &clock_id);

	mat4 a = {1.3, 2.3, 3.3, 4.3, 5.3, 6.3, 7.3, 8.3, 
				9.3, 10.3, 11.3, 12.3, 13.3, 14.3, 15.3, 16.3};
	mat4 b = {1.1, 2.1, 3.1, 4.1, 5.1, 6.1, 7.1, 8.1, 
				9.1, 10.1, 11.1, 12.1, 13.1, 14.1, 15.1, 16.1};
	mat4 c, d;
	print_mat4("a", &a);
	print_mat4("b", &b);

	mat4_dot_mat4(&a, &b, &c);
	print_mat4("a*b avx fast", &c);

	slow_mat4_dot_mat4(&a, &b, &d);
	print_mat4("a*b slow", &d);

	printf ("caculate 10M times \n");
	/* avx mode mat4 dot mat4 */
	struct timespec s1, s2;
	clock_gettime(clock_id, &s1);
	for (int i = 0; i < 10000000; i++) {
		mat4_dot_mat4(&a, &b, &c);
	}
	clock_gettime(clock_id, &s2);
	printf("fast: %ld ns\n", (s2.tv_sec - s1.tv_sec) * 1000000000 + 
			(s2.tv_nsec - s1.tv_nsec));

	clock_gettime(clock_id, &s1);
	for (int i = 0; i < 10000000; i++) {
		slow_mat4_dot_mat4(&a, &b, &c);
	}
	clock_gettime(clock_id, &s2);
	printf("slow: %ld ns\n", (s2.tv_sec - s1.tv_sec) * 1000000000 + 
			(s2.tv_nsec - s1.tv_nsec));

}


