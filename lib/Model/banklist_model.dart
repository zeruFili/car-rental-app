class Bank {
  final int id; // Make this non-nullable
  final String name; // Make this non-nullable

  Bank({
    required this.id, // Use required to ensure a value is provided
    required this.name, // Use required to ensure a value is provided
  });
}

List<Bank> bankList = [
  Bank(id: 130, name: "Abay Bank"),
  Bank(id: 772, name: "Addis International Bank"),
  Bank(id: 207, name: "Ahadu Bank"),
  Bank(id: 656, name: "Awash Bank"),
  Bank(id: 347, name: "Bank of Abyssinia"),
  Bank(id: 571, name: "Berhan Bank"),
  Bank(id: 128, name: "CBEBirr"),
  Bank(id: 946, name: "Commercial Bank of Ethiopia (CBE)"),
  Bank(id: 893, name: "Coopay-Ebirr"),
  Bank(id: 880, name: "Dashen Bank"),
  Bank(id: 1, name: "Enat Bank"),
  Bank(id: 301, name: "Global Bank Ethiopia"),
  Bank(id: 534, name: "Hibret Bank"),
  Bank(id: 315, name: "Lion International Bank"),
  Bank(id: 266, name: "M-Pesa"),
  Bank(id: 979, name: "Nib International Bank"),
  Bank(id: 855, name: "telebirr"),
  Bank(id: 472, name: "Wegagen Bank"),
  Bank(id: 687, name: "Zemen Bank"),
];
