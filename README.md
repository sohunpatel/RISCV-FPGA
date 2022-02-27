# A simple RISC V implementation
### Project Overview
The project is my attempt to understand digital implementation of computing architectures and the problems and difficulty in the process. Due to this, this is a very barebones processor that is not meant for any use outside of education. Formal verification methods will be tried and perused, but will not necessarily gaurantee performance any performance of the processor.
### Current Status
Going through a redesign stage to formulate clear design goals and high level flow designs. The project was previously a jumbled mess of inspiration from other projects and, thus, verification of the project was a nightmare.
### Roadmap
- Well, first getting the design of the process figured out
- Creating a verification methods for the components that need to be made (hopefully using UVM)
- Develop components that can meet the verification tests aforementioned
- Integrate individual components to create a CPU core
- Create buses for interacting with peripherals and memory (AXI or wishbone)
