#include <stdio.h>
#include <stdlib.h>
#include <time.h>

double glfwGetTime();

void setuprand() {
  time_t t;

  srand((unsigned)time(&t));
}

float randf() { return (float)rand() / (float)RAND_MAX; }

void printfloat(float error) { printf("float: %f\n", error); }
void printline(char *line) { printf("%s\n", line); }

void printint(int error) { printf("int: %u\n", error); }

float getTimeFloat() {
  double res = glfwGetTime();
  return (float)res;
}
