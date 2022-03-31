extension Exists<S, T> on T? {
  S? exists(S Function(T) f) => (this == null) ? null : f(this!);
}
