class Constants {
  // townships and villages combined
  static const List<Map<String, dynamic>> townshipVillage = [
    {
      'township': 'Township One',
      'villages': [
        'Village One',
        'Village Two',
        'Village Three'
      ],
    },
    {
      'township': 'Township Two',
      'villages': [
        'Village Four',
        'Village Five',
        'Village Six'
      ]
    },
    {
      'township': 'Township Three',
      'villages': [
        'Village Seven',
        'Village Eight',
        'Village Nine'
      ],
    },
  ];
  // townships
  static const List<String> townships = [
    'Township One',
    'Township Two',
    'Township Three'
  ];

  // months
  static const List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // filter months not to include future months
  static List<String> getFilteredMonths() {
    final currentMonth = DateTime.now().month;
    return months.sublist(0, currentMonth);
  }

  // Generate a list of years
  static List<String> generateYearList() {
    int currentYear = DateTime.now().year;
    return List.generate(2, (index) => (currentYear - 1 + index).toString());
  }

  static const List<String> jobs = [
    'Farming',
    'Rubber Platation',
    'Construction',
    'Forestry',
    'Mining',
    'Other'
  ];
}