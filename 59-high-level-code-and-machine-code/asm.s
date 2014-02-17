.global main
.func main
main:
	mov r1, #3 /* set r1 to 3 */
	mov r2, #4 /* set r2 to 4 */
	add r0, r1, r2 /* set r0 to the sum of r1 + r2 */
	bx lr /* halt */
