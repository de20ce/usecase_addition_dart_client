ARTIFACTS=

ARTIFACTS += src/usecase/lib/src/addition.pb.dart
ARTIFACTS += src/usecase/lib/src/addition.pbenum.dart
ARTIFACTS += src/usecase/lib/src/addition.pbgrpc.dart
ARTIFACTS += src/usecase/lib/src/addition.pbjson.dart

createdartlib:
	dart create --template=package --force src/usecase

createflutterapp:
# Create the gui app inside the src/app directory
	flutter create --platform android --project-name gui -e src/app

installdartpackage:
# This directive should be run inside your flutter project
	cd src/usecase && flutter pub add protobuf grpc


dartproto:
# -Iprotos flag allow to define the proto directory. For Dart, this
# directory seems to start with the name "protos" in its root directory
	protoc --dart_out=grpc:src/usecase/lib/src -Iprotos ./protos/addition.proto

all: createdartlib dartproto 

.PHONY: all

clean:
	rm -f ${ARTIFACTS}