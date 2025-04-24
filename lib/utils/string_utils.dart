/// Utility functions for string manipulation
library;

/// Capitalizes the first letter of a string and makes the rest lowercase
String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

/// Formats a date string to a more readable format
String formatDateString(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    return '${date.day}-${date.month}-${date.year}';
  } catch (e) {
    return dateString; // Return original if parsing fails
  }
}

/// Converts malaria parasite name to its abbreviation
String getMpInitials(String mp) {
  switch (mp.toLowerCase()) {
    case 'plasmodium falciparum':
      return 'Pf';
    case 'plasmodium vivax':
      return 'Pv';
    case 'mixed':
      return 'Mixed';
    default:
      return 'N/A';
  }
}
