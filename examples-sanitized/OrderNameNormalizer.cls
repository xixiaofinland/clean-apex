public with sharing class OrderNameNormalizer {
    public String normalize(String input) {
        if (String.isBlank(input)) {
            return input;
        }

        List<String> words = input.trim().toLowerCase().split('\\s+');
        List<String> normalizedWords = new List<String>();

        for (String word : words) {
            if (String.isBlank(word)) {
                continue;
            }
            normalizedWords.add(word.left(1).toUpperCase() + word.substring(1));
        }
        return String.join(normalizedWords, ' ');
    }
}
