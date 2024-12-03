/**
 * @name SQLI Vulnerability
 * @description Using untrusted strings in a sql query allows sql injection attacks.
 * @kind problem
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

from DataFlow::Node source, DataFlow::Node sink
where MyFlow::flow(source, sink)
select source, "Taintflow to $@.", sink, sink.toString()
