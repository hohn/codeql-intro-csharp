/**
 * @name SQLI Vulnerability
 * @description Using untrusted strings in a sql query allows sql injection attacks.
 * @kind problem
 * @id workshop/sqlivulnerable
 * @problem.severity warning
 */

import csharp

/*
 *    2. Identify the /sink/ part of the
 *      : var command = new SqliteCommand(query, connection))
 *      expression, the =query= argument.
 */

from ObjectCreation oc, Expr queryArg
where
  oc.getObjectType().getName() = "SqliteCommand" and
  oc.getArgument(0) = queryArg
select queryArg, "Sink identified: " + queryArg.toString()
