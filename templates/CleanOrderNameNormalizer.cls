/**
 * TEMPLATE METADATA - DO NOT REMOVE
 * clean-apex: allow=AUTO_JAVADOC
 *
 * Template: CleanOrderNameNormalizer
 * Layer: oo
 * Purpose: Data transformation and normalization logic for domain objects
 * Usage Pattern: OO
 * Dependencies: None
 *
 * INSTRUCTIONS:
 * 1. Replace "CleanOrderName" with your transformation purpose
 * 2. Implement normalize() or transform() methods for your use case
 * 3. Keep stateless for testability (pure functions)
 * 4. Use in OO layer or service layer for data transformation
 * 5. Remove this header once customized
 */
public with sharing class CleanOrderNameNormalizer {
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
