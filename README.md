
UseCase Client Side SetUp
-------------------------

The goal of the project is to show how one can connect 2 or more apps written in different languages thanks to gRPC.

Here, in the client repo, we will be working with only Dart code. Out there,
we will be using from the server side, Python(mainly), Golang or Dart. The server code is in another repo. 

This client project has been managed by:
> - [Espera **Awo**](https://github.com/esperaking81) as the Dart/Flutter tech specialist and adviser.
> - [Vincent **Whannou de Dravo**](https://github.com/de20ce) as the tech lead and the project manager.


## Project Directory Organisation

```
.
├── protos
└── src
    ├── app
    │   ├── android
    │   ├── build
    │   └── lib
    ├── cmd
    │   ├── bin
    │   ├── lib
    │   └── test
    └── usecase
        ├── example
        ├── lib
        └── test

```
The `src` directory contains `3` directories. `app` contains the Flutter apps, i.e the GUI. `cmd` contains the CLI version of the Flutter app, while `usecase` contains the generated stubs from `protos` directory.



# gui

A new Flutter project

# Credit
https://davidnwaneri.com/building-a-custom-numeric-keypad-in-flutter
https://learn.microsoft.com/en-us/aspnet/core/grpc/performance?view=aspnetcore-8.0
