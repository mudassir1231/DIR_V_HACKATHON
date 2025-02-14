#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>  // For rand() and srand()
#include <time.h>    // For seeding random number generator

// Matrix dimensions
#define INPUT_ROWS 8
#define INPUT_COLS 8
#define KERNEL_ROWS 3
#define KERNEL_COLS 3
#define OUTPUT_ROWS (INPUT_ROWS - KERNEL_ROWS + 1)
#define OUTPUT_COLS (INPUT_COLS - KERNEL_COLS + 1)

// Function to lower the tensor (flatten the matrix)
int lowerTensor(int8_t input[INPUT_ROWS][INPUT_COLS], int8_t flattened[INPUT_ROWS * INPUT_COLS]) {
    int index = 0;
    for (int i = 0; i < INPUT_ROWS; ++i) {
        for (int j = 0; j < INPUT_COLS; ++j) {
            flattened[index++] = input[i][j];
        }
    }
}

// Function to preprocess the input by normalizing it to range [-1, 1]
int preprocess(int8_t input[INPUT_ROWS][INPUT_COLS], float normalized[INPUT_ROWS][INPUT_COLS]) {
    int8_t max_value = 7;  // Assuming 7 is the max input range for int8_t
    for (int i = 0; i < INPUT_ROWS; ++i) {
        for (int j = 0; j < INPUT_COLS; ++j) {
            normalized[i][j] = (float)input[i][j] / max_value;
        }
    }
}

// Function to perform 2D convolution on the preprocessed data
void Convolution2D(float input[INPUT_ROWS][INPUT_COLS], int8_t kernel[KERNEL_ROWS][KERNEL_COLS], int8_t result[OUTPUT_ROWS][OUTPUT_COLS]) {
    for (int i = 0; i < OUTPUT_ROWS; ++i) {
        for (int j = 0; j < OUTPUT_COLS; ++j) {
            int16_t sum = 0;  // Use int16_t to prevent overflow
            // Element-wise multiplication and summation over the kernel
            for (int m = 0; m < KERNEL_ROWS; ++m) {
                for (int n = 0; n < KERNEL_COLS; ++n) {
                    sum += (int16_t)(input[i + m][j + n] * 127) * (int16_t)kernel[m][n];  // Scaling normalized input back
                }
            }
            // Cast back to int8_t and store result
            result[i][j] = (int8_t)sum;
        }
    }
}

// Post-process by clipping the results to valid int8_t range and adding bias
int postProcess(int8_t result[OUTPUT_ROWS][OUTPUT_COLS], int8_t bias) {
    for (int i = 0; i < OUTPUT_ROWS; ++i) {
        for (int j = 0; j < OUTPUT_COLS; ++j) {
            int16_t value = result[i][j] + bias;  // Adding bias
            if (value > 127) value = 127;
            if (value < -128) value = -128;
            result[i][j] = (int8_t)value;
        }
    }
}

// Function to generate a random input matrix
int generateRandomInput(int8_t input[INPUT_ROWS][INPUT_COLS]) {
    for (int i = 0; i < INPUT_ROWS; ++i) {
        for (int j = 0; j < INPUT_COLS; ++j) {
            input[i][j] = rand() % 8;  // Generate random values between 0 and 7
        }
    }
}

// Function to print a matrix
int printMatrix(int8_t matrix[OUTPUT_ROWS][OUTPUT_COLS]) {
    for (int i = 0; i < OUTPUT_ROWS; ++i) {
        for (int j = 0; j < OUTPUT_COLS; ++j) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
}

int main() {
    // Seed the random number generator
    srand(time(0));

    // Define a 3x3 kernel
    int8_t kernel[KERNEL_ROWS][KERNEL_COLS] = {
        {-1, 0, 1},
        {-1, 0, 1},
        {-1, 0, 1}
    };

    // Step 1: Generate a random 8x8 input matrix
    int8_t input[INPUT_ROWS][INPUT_COLS];
    generateRandomInput(input);

    // Step 2: Lower the tensor (optional step)
    int8_t flattened[INPUT_ROWS * INPUT_COLS];
    lowerTensor(input, flattened);

    // Step 3: Preprocess (normalize) the input matrix
    float normalized[INPUT_ROWS][INPUT_COLS];
    preprocess(input, normalized);

    // Step 4: Perform the convolution on the normalized input
    int8_t result[OUTPUT_ROWS][OUTPUT_COLS];
    Convolution2D(normalized, kernel, result);

    // Step 5: Post-process (add bias and clip values)
    int8_t bias = 1;  // Adding a bias of 1 to the result for demonstration
    postProcess(result, bias);

    // Display the result
    printf("Final Convolution Result (after post-processing):\n");
    printMatrix(result);

    return 0;
}
