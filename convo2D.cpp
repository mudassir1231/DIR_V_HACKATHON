#include <iostream>
#include <vector>
#include <cstdint>  // For int8_t

// Typedef for a 2D matrix using vector of vectors
using Matrix = std::vector<std::vector<int8_t>>;

// Function to perform 2D convolution
Matrix Convolution2D(const Matrix& input, const Matrix& kernel) {
    const int kernel_rows = kernel.size();
    const int kernel_cols = kernel[0].size();
    const int input_rows = input.size();
    const int input_cols = input[0].size();
    const int rows = (input_rows - kernel_rows) + 1;
    const int cols = (input_cols - kernel_cols) + 1;

    // Initialize the result matrix with zeros
    Matrix result(rows, std::vector<int8_t>(cols, 0));

    // Perform convolution
    for (int i = 0; i < rows; ++i) {
        for (int j = 0; j < cols; ++j) {
            int16_t sum = 0;  // Using int16_t for accumulation to prevent overflow
            // Element-wise multiplication and summation over the kernel
            for (int m = 0; m < kernel_rows; ++m) {
                for (int n = 0; n < kernel_cols; ++n) {
                    sum += static_cast<int16_t>(input[i + m][j + n]) * static_cast<int16_t>(kernel[m][n]);
                }
            }
            result[i][j] = static_cast<int8_t>(sum);  // Cast the result back to int8_t
        }
    }

    return result;
}

// Helper function to print a matrix
void printMatrix(const Matrix& matrix) {
    for (const auto& row : matrix) {
        for (const auto& elem : row) {
            std::cout << static_cast<int>(elem) << " ";  // Cast to int to display correctly
        }
        std::cout << "\n";
    }
}

int main() {
    // Define a 3x3 kernel
    Matrix kernel = {
        {-1, 0, 1},
        {-1, 0, 1},
        {-1, 0, 1}
    };

    std::cout << "Kernel:\n";
    printMatrix(kernel);
    std::cout << "\n";

    // Define an 8x8 input matrix
    Matrix input = {
        {2, 1, 0, 2, 5, 6, 1, 3},
        {4, 4, 1, 1, 4, 7, 0, 5},
        {5, 4, 0, 4, 1, 2, 8, 1},
        {1, 2, 2, 1, 3, 4, 7, 2},
        {6, 3, 1, 0, 5, 2, 4, 3},
        {3, 1, 0, 1, 3, 3, 1, 0},
        {1, 4, 7, 3, 2, 3, 5, 2},
        {5, 2, 3, 6, 1, 4, 3, 1}
    };

    std::cout << "Input:\n";
    printMatrix(input);
    std::cout << "\n";

    // Perform the convolution
    Matrix output = Convolution2D(input, kernel);

    // Display the result
    std::cout << "Convolution Result:\n";
    printMatrix(output);

    return 0;
}
