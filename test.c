#define STB_IMAGE_IMPLEMENTATION
#include "engine/stb_image.h"
#include <time.h>

double glfwGetTime();

void setuprand() {
  time_t t;

  srand((unsigned) time(&t));
}

float randf() {
  return (float)rand() / RAND_MAX;
}

void printfloat(float error) {
  printf("float: %f\n", error);
}

void printint(int error) {
  printf("int: %u\n", error);
}

float getTimeFloat() {
  double res = glfwGetTime();
  return (float)res;
}
