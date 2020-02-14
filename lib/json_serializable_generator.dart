import 'package:build/build.dart';
import 'package:json_serializable_generator/src/serializable_model_builder.dart';

/// Returns the Instance for the model class Builder
Builder jsonSerializableGenerator(BuilderOptions builderOptions) =>
    SerializableModelBuilder();
