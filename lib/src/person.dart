class Person {
	final String name;
  String timezone;
	
	Person(this.name);

  operator ==(other) => other is Person && name == other.name && timezone == other.timezone;

  int get hashCode => name.hashCode + timezone.hashCode;
}
