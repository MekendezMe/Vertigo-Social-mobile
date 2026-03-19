import 'package:kiwi/kiwi.dart';
import 'package:social_network_flutter/common/framework/di/di_assembly.dart';

typedef DIFactory<T> = T Function(DIContainer container);

/// Контейнер зависимостей. Хранит зависимости и предоставляет к ним доступ.
/// Используется один контейнер на приложение.
class DIContainer {
  final KiwiContainer _container;

  /// По-умолчанию регистрация двух одинаковых зависимостей считается ошибкой.
  /// Чтобы разрешить переопределение нужно установить это флаг в true.
  bool allowOverride = false;

  DIContainer() : _container = KiwiContainer();

  DIContainer._(KiwiContainer container) : _container = container;

  static DIContainer get scoped {
    return DIContainer._(KiwiContainer.scoped());
  }

  void registerInstance<S>(S instance, {String? name}) {
    _removeIfExists<S>(name);
    _container.registerInstance<S>(instance, name: name);
  }

  void registerFactory<S>(DIFactory<S> factory, {String? name}) {
    _removeIfExists<S>(name);
    _container.registerFactory((_) => factory(this), name: name);
  }

  void registerSingleton<S>(DIFactory<S> factory, {String? name}) {
    _removeIfExists<S>(name);
    _container.registerSingleton((_) => factory(this), name: name);
  }

  T resolve<T>([String? name]) {
    return _container.resolve<T>(name);
  }

  void registerAssemblies(List<DIAssembly> assemblies) {
    for (DIAssembly a in assemblies) {
      a.assembly(this);
    }
  }

  void _removeIfExists<S>([String? name]) {
    if (!allowOverride) return;

    try {
      _container.unregister<S>(name);
    } on Error {
      // Обработка не требуется
    }
  }
}
