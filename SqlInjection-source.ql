/**
 * @name SQLI Vulnerability
 * @description Using untrusted strings in a sql query allows sql injection attacks.
 * @kind problem
 * @id workshop/sqlivulnerable
 * @problem.severity warning
 */

import csharp

/*
 * 1. Identify the /source/ part of the
 * : Console.ReadLine()?.Trim() ?? string.Empty;
 * : read(STDIN_FILENO, buf, BUFSIZE - 1);
 * expression, the =Console.ReadLine()= call.
 */

from MethodCall call
where
  call.getTarget().getDeclaringType().hasFullyQualifiedName("System", "Console") and
  call.getTarget().getName() = "ReadLine"
select call, "Source identified: " + call.toString()
