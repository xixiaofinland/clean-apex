# Error Handling

Exceptions encountered in Apex should be thrown up to the entry-point and handled
there in the try-catch's catch block.

Do not swallow exceptions without a solid reason. If needed, write the exception
info into logs and swallow only if it's required by business needs.
