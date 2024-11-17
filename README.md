# Assignment 2: Classify

TODO: Add your own descriptions here.

classify:
The key functionalities include reading matrices, performing matrix multiplication, applying ReLU activation, and finding the classification result. Matrix multiplication is implemented manually using bitwise operations and repeated addition, ensuring compatibility without relying on hardware multiplication. The program also manages dynamic memory for matrix storage, with proper error handling for argument validation and memory allocation failures. Efficient loop control structures are used throughout the matrix operations to maintain performance and simplicity.

This implementation highlights the core principles of neural network computation in assembly language, addressing challenges like manual multiplication, memory management, and efficient loop control. The project demonstrates effective handling of low-level arithmetic and dynamic memory while providing insights into the complexities of assembly programming for neural network tasks.

abs:
Making any number be positive.

argmax:
Manual multiplication was implemented using repeated addition and bitwise operations to handle both positive and negative numbers. Dynamic memory allocation was carefully managed to avoid memory leaks, and efficient loop structures were used to minimize redundant memory operations during matrix processing. The argmax function was developed to find the position of the maximum element in an array, returning the first occurrence in case of ties. Overall, this project highlights the intricacies of implementing a neural network classifier in RISC-V assembly, including low-level arithmetic, memory management, and efficient control flow.

dot:
Tow matrixs inplement dot function for corresponding element.

matmul:
Manual multiplication was implemented using repeated addition and bitwise operations to handle both positive and negative numbers. Dynamic memory allocation was carefully managed to avoid memory leaks, and efficient loop structures were used to minimize redundant memory operations during matrix processing. Another major component was the matrix multiplication (matmul) function, which multiplies two matrices (m0 and m1) to obtain the result (D). The complexity of handling nested loops and ensuring correct memory access patterns were among the main challenges. The implementation of the dot function, which computes the dot product of rows and columns with strides, was critical to the matrix multiplication functionality. Overall, this project highlights the intricacies of implementing a neural network classifier in RISC-V assembly, including low-level arithmetic, memory management, and efficient control flow.

relu:
The ReLU activation function (relu) is implemented to ensure non-linearity in the neural network by setting negative values to zero. This function processes each element of the array in-place, iterating through the array and modifying any negative value directly in memory. The main challenge was handling the loop efficiently to ensure correct indexing and memory access. Proper validation is also implemented to ensure the array is non-empty before proceeding, with an error code (36) returned in case of invalid input. This careful handling of memory and edge cases helps maintain the robustness of the ReLU operation.

read_matrix:
The read_matrix function in this project is responsible for loading matrix data from a binary file into dynamically allocated memory. This function reads the matrix dimensions from the file header and stores them at provided addresses. One major challenge was handling the multiplication of matrix dimensions without relying on the built-in mul instruction, as required by the project guidelines. This required a manual implementation of multiplication using bitwise operations, which involved handling both positive and negative values, as well as efficiently computing the product using a series of shifts and additions.

write_matrix:
The write_matrix function first opens the specified file, writes the matrix dimensions (number of rows and columns), and then writes the matrix data itself. A key challenge was implementing multiplication (mul) without relying on hardware support, as required by the assignment. This was addressed by manually implementing a bitwise multiplication algorithm, which involved iteratively adding shifted values to compute the final product. This approach was necessary for compatibility with systems that do not support direct multiplication instructions. Additionally, careful error handling was added to address potential issues with file operations, ensuring that the program could handle errors like file access or write failures gracefully.
