within Annex60.Utilities.Math.Functions;
function smoothMin
  "Once continuously differentiable approximation to the minimum function"
  input Real x1 "First argument";
  input Real x2 "Second argument";
  input Real deltaX "Width of transition interval";
  output Real y "Result";
algorithm
  y := Annex60.Utilities.Math.Functions.spliceFunction(
       pos=x1, neg=x2, x=x2-x1, deltax=deltaX);
  annotation (
Documentation(smoothOrder = 1,info="<html>
<p>
Once continuously differentiable approximation to the <code>min(.,.)</code> function.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 5, 2015, by Filip Jorissen:<br/>
Added <code>smoothOrder = 1</code>.
</li>
<li>
August 15, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end smoothMin;