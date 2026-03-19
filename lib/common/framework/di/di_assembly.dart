import 'di_container.dart';

/// Сборка, регистрирует зависимости в контейнере.
/// Каждый модуль создает свою сборку, в которой создается граф зависимостей,
/// использующихся в этом модуле.
abstract class DIAssembly {
  assembly(DIContainer container);
}
