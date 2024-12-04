/**
 * @name SQLI Vulnerability
 * @description Using untrusted strings in a sql query allows sql injection attacks.
 * @kind path-problem
 * @id workshop/sqlivulnerable
 * @problem.severity warning
 */

import csharp

module MyFlowConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(MethodCall call |
      call.getTarget().getDeclaringType().hasFullyQualifiedName("System", "Console") and
      call.getTarget().getName() = "ReadLine" and
      source.asExpr() = call
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(ObjectCreation oc, Expr queryArg |
      oc.getObjectType().getName() = "SqliteCommand" and
      oc.getArgument(0) = queryArg and
      sink.asExpr() = queryArg
    )
  }
}

module MyFlow = TaintTracking::Global<MyFlowConfiguration>;
import MyFlow::PathGraph

from MyFlow::PathNode source, MyFlow::PathNode sink
where MyFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Taintflow found"
