within IBPSA.Fluid.HeatPumps.ModularReversible;
package UsersGuide
  "User's Guide for modular reversible heat pump and chiller models"
  extends Modelica.Icons.Information;
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
  The packages <a href=\"modelica://IBPSA.Fluid.HeatPumps\">IBPSA.Fluid.HeatPumps</a>
  and <a href=\"modelica://IBPSA.Fluid.Chillers\">IBPSA.Fluid.Chillers</a> contain 
  the modular approach to model reversible refrigeration 
  machines (heat pumps and chillers) based on grey-box approaches.
  Either empirical data or physical equations are used to model 
  the refrigerant cycle. The model for a refrigerant cycle calculates
  the electrical power consumption <code>PEle</code>, 
  the condenser heat flow <code>QCon_flow</code>, 
  and the evaporator heat flow <code>QEva_flow</code>
  based on available variables of the sink- and source-stream.
  Thus, this model does not enable closed-loop simulations of 
  the refrigerant cycle. However, such models are (1) 
  either instable or commercial and (2) require substainial computing times.
  When simulating the refrigerant machine in a more complex energy system, 
  this modular approach enables (1) detailed performance and 
  dynamic behaviour and (2) fast computating times.
</p>
<p>
  This UserGuide will help you understand how to use the models associated 
  with the modular approach.
  The approach was presented at the Modelica Conference 2021.
  If you want to check out the paper, please see the section <b>References</b>.
</p>
  
<h4>Why modular models?</h4>
<p>
  Heat pumps and chillers are versital machines:
</p>
<ul>
<li>
  They use different sources (air, water, brine, etc.) 
  and sinks (air, water, brine, etc.)
</li>
<li>
  They may be on/off and inverter driven
</li>
<li>
  They are able reverse the operation from heating to cooling
  and vice versa
</li>
<li>
  The application limits (or operational envelopes) can 
  strongly influence whether using the device is even
  possible
</li>
<li>
  The design depends on several nominal boundary conditions
</li>
<li>
  Internal safety controls influence the control
</li>
</ul>
<p>
  To what extend you need to model all these effects depends
  on your simulation aim. Maybe a simple Carnot approach is 
  sufficient, maybe you need more detailed performance data 
  and a realistic control behaviour.
</p>
<p>
  The modular approach let's you disable any irrelevant features,
  select existing model approaches and most importantly enables and 
  easy addition of new model approaches. 
  Relevant components are declared as <code>replaceable</code>. 
  Replaceable models are <code>constrainedby</code> partial models
  which you are free to extend. Thus, you can insert new model approaches
  into the framework of the ModularReversible model approach. 
  If you are not familiar with replaceable models in Modelica, 
  pre-defined model options exist. With these, you don't have to worry
  about redclaring replaceable models. 
</p>

<h4>Package and model structure</h4>

<p>
  This sections explain the inheritance and model package structure
  to help you navigate through all options and check out the 
  detailed documentation of each model for further information.
</p>
<p>
  All modular heat pump or chiller models base on the model 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle</a>.
  This partial model declares all common interfaces, parameters etc.
</p>

<h5>Heat pump models</h5>
<p> 
For heat pumps, the model <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible\">
IBPSA.Fluid.HeatPumps.ModularReversible.ModularReversible</a> extends the partial model and adds
the connector <code>hea</code> to choose 
between the operation type of the heat pump:
</p>
<ul>
<li><code>hea = true</code>: Main operation mode (heating) </li>
<li><code>hea = false</code>: Reversible operation mode (cooling) </li>
</ul>

Furthermore, the refrigerant cycle is redeclared to use the one for 
the heat pump 
<a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle\">
IBPSA.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle</a>.
This refrigerant cycle in turn contains replaceable models for the 
heating and cooling operation of the heat pump.
Available approaches can be found in the package: 
<a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle\">
IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle</a>
For more information on the refrigerant cycle models, we refer
to the section <b>Refrigerant cycle models</b>.

<p>
  Extending the ModularReversible model, 
  several pre-configured approaches exist.
  Please check out the documentation of each approach
  to check if this approach may suit you.
</p>
<ul>
<li>
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.LargeScaleWaterToWater\">
  IBPSA.Fluid.HeatPumps.ModularReversible.LargeScaleWaterToWater</a>
</li>
<li>
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ReversibleAirToWaterEuropeanNorm2D\">
  IBPSA.Fluid.HeatPumps.ModularReversible.ReversibleAirToWaterEuropeanNorm2D</a>
</li>
<li>
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.ReversibleCarnotWithLosses\">
  IBPSA.Fluid.HeatPumps.ModularReversible.ReversibleCarnotWithLosses</a>
</li>
</ul>

<h5>Chiller models</h5>

<p> 
For chillers, the model <a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.ModularReversible\">
IBPSA.Fluid.Chillers.ModularReversible.ModularReversible</a> extends the partial model and adds
the connector <code>coo</code> to choose 
between the operation type of the chiller:
</p>
<ul>
<li><code>coo = true</code>: Main operation mode (cooling) </li>
<li><code>coo = false</code>: Reversible operation mode (heating) </li>
</ul>

Furthermore, the refrigerant cycle is redeclared to use the one for 
the chiller
<a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.BaseClasses.RefrigerantCycle\">
IBPSA.Fluid.Chillers.ModularReversible.BaseClasses.RefrigerantCycle</a>.
This refrigerant cycle in turn contains replaceable models for the 
cooling and heating operation of the chiller.
Available approaches can be found in the package: 
<a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle\">
IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle</a>. 
For more information on the refrigerant cycle models, we refer
to the section <b>Refrigerant cycle models</b>.

<p>
  Extending the ModularReversible model, 
  several pre-configured approaches exist.
  Please check out the documentation of each approach
  to check if this approach may suit you.
</p>
<ul>
<li>
  <a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.LargeScaleWaterToWater\">
  IBPSA.Fluid.Chillers.ModularReversible.LargeScaleWaterToWater</a>
</li>
<li>
  <a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.ReversibleCarnotWithLosses\">
  IBPSA.Fluid.Chillers.ModularReversible.ReversibleCarnotWithLosses</a>
</li>
</ul>

<h4>Connectors</h4>

<p>
  Aside from the aforementioned Boolean signals 
  <code>hea</code> and <code>coo</code>, the following
  connectors are relevant to understand how the model works: 
  Compressor speed and the expandable bus connector.
  
  The ambient temperatures <code>TEvaAmb</code> and <code>TConAmb</code> are
  only relevant for the heat losses.
  The fluid ports are explained in more detail here:
<a href=\"modelica://IBPSA.Fluid.UsersGuide\">IBPSA.Fluid.UsersGuide</a>.
</p>

<h5>Compressor speed</h5>

<p>
  The input <code>ySet</code> represents the relative compressor speed.
  To model both on/off and inverter controlled refrigerant machines, 
  the compressor speed is normalizd to a relative value between 0 and 1.
  If you do not want to model an inverter driven heat pump, you have
  to limit the value yourself.
  
  If your application contains data in Hz or similar, consider converting
  the input according to the maximal allowed value.
</p>
<p>
  We use the notation <code>Set</code> to indicate that this is not
  necessarily the applied compressor speed. As internal safety controls
  may prohibit certain operating points, the applied compressor speed
  is the one contained in the bus connector <code>sigBus</code>, which
  is equal to the output <code>yOut</code> of the safety control.
</p>

<h5>Expandable bus connector</h5>

<p>
  As the modular approach may require arbitrary information to model
  the refrigerant cycle behaviour, all available states and outputs
  are aggregated in the expandable bus connector <code>sigBus</code>.
  For instance, in order to control both chillers and heat pumps, 
  both flow and return temperature are relevant. The bus connector
  offers valuable information when analyzing the model behaviour, as 
  all relevant variables are contained within.
</p>

<h4>Refrigerant cycle models</h4>

<p>
  A replaceable refrigerant cycle model for heating or 
  cooling has to calculate the electrical power consumption
  <code>PEle</code>, condenser heat flow <code>QCon_flow</code> 
  and evaporator heat flow <code>QEva_flow</code> based on the 
  values in the <code>sigBus</code>.
  Extending the model 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialHeatPumpCycle</a>
  for heat pumps and 
  <a href=\"modelica://IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle\">
  IBPSA.Fluid.Chillers.ModularReversible.RefrigerantCycle.BaseClasses.PartialChillerCycle</a>
  for chillers enables just that.
</p>
<p>
  Currently, two approaches for refrigerant cycle models exist in the IBPSA.
  First, the <code>ConstantQualityGrade</code> model uses the same 
  equations as the existing Carnot models in the IBPSA.
  Second, the <code>EuropeanNorm2D</code> provides performance data
  based on the European Norm 14511 using 2D-tables.
</p>
<p>
  Two additional approaches exist in the AixLib library.
  These approaches require the use of the SDF-library, as
  the compressor speed influences the model output as a third 
  dimension. Currently, more than 2D tables are not supported in 
  the Modelica Standard Library.
  The first approach is similar to <code>EuropeanNorm2D</code>
  approach buts adds the 3rd dimension of compressor speed.
  The second approach is based on white-box stationary python models
  for closed-loop refrigerant cycles. The model has been empirically 
  validated and can take up to n-dimensions.
  If your simulation aim requires more detailed data, be sure
  to check out the models in the AixLib or contact the authors.
</p>


<h4>Parameterization and naming</h4>
<p>
  The refrigerant cycle models will output
  varying heat flow rates and electrical power consumptions. 
  This is based on the fact that refrigerant cycle performance 
  depend heavily on the boundary conditions.
</p>
<p>
  Still, the user needs to size the device or the system 
  according to some reference point. Accordingly, we follow
  the basic IBPSA concept for nominal conditions, explained in 
  detail here: 
  <a href=\"modelica://IBPSA.Fluid.UsersGuide\">IBPSA.Fluid.UsersGuide</a>
</p>
<p>
  The nominal heat flow rate of the device for its main 
  usage is called <code>QUse_flow_nominal</code>. 
  For heat pumps, it is the nominal 
  condenser heat flow rate <code>QCon_flow_nominal</code>.
  For chillers, it is the nominal 
  evaporator heat flow rate <code>QEva_flow_nominal</code>.
  This nominal heat flow rate is only valid at the 
  nominal conditions of the
<ul>
<li>
  condenser temperature <code>TCon_nominal</code>,
</li>
<li>
  evaporator temperature <code>TEva_nominal</code>,
</li>
<li>
  condenser temperature difference<code>dTCon_nominal</code>,
</li>
<li>
  evaporator temperature difference<code>dTEva_nominal</code>,
</li>
<li>
  condenser mass flow rate <code>mCon_flow_nominal</code>
</li>
<li>
  evaporator mass flow rate <code>mCon_flow_nominal</code>
</li>
<li>
  compressor speed <code>ySet_nominal</code>
</li>
</ul>
<p>
  The temperature differences and mass flow rates presuppose each other.
  The temperature levels are whithout further specification of 
  inlet or outlet on purpose. Some refrigerant cycle models will
  use the inlet, some the outlet to determine the outputs.
</p>
<p>
Other parameters, such as the nominal pressure drops or 
advanced model settings will not influence the refrigerant cycle
models. Thus, only the listed nominal conditions are contained
in both the ModularReversible models and the refrigerant cycle models
for heating and cooling.
</p>


<h4>Sizing</h4>

<p>
  At the nominal conditions, the refrigerant cycle model will
  calculate the useful nominal heat flow rate, which is 
  named <code>QUseNoSca_flow_nominal</code>. This value is probably 
  not equal to the required <code>QUse_flow_nominal</code>, 
  which is the required sizing for the energy system. 
  For instance, say you need a 7.6 kW heat pump, 
  but the EN 14511 datasheets may only provide 5 kW and 10 kW options.
  In such cases, the performance data and relevant parameters 
  are scaled using a scaling factor <code>scaFac</code>.
  Resulting, the refrigerant machine can supply more or less heat with 
  the COP staying constant. However, one has to make sure 
  that the movers in use also scale with this factor.
</p>
<p>
  Both <code>QUseNoSca_flow_nominal</code> and <code>scaFac</code>
  are calculated in the refrigerant cycle models. 
  The <code>scaFac</code> is propagated to the 
  uppermost layer of the ModularReversible models.
  If both heating and cooling operation is enabled 
  using <code>use_rev</code>, the scaling of the secondary 
  operation is overwritten by the one in the primary operation.
</p>
  
<h4>Safety controls</h4>

<p>
  Refrigerant machines contain internal safety controls, 
  prohibiting operations in possibly unsafe points. 
  All ModularReversible models account for such safety controls. 
  All options can be disabled, if required. 
  Please look at the model description for more info:
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Safety\">
  IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Safety</a>
</p>

<h4>Refrigerant cycle inertia</h4>

<p>
  As the currently existing refrigerant cycle model approaches
  are based on stationary data points, any intertia
  (mass and thermal) of components inside the refrigerant cycle 
  (compressor, pipes, expansion valve, fluid, etc.) is neglected. 
  To overcome this issue, a replaceable SISO model
  enables you to model the refrigerant cycle inertia based on your needs.
</p>
<p>
  The package 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias</a>
  holds existing approaches. In the contribution, an empirical 
  validation showed that a third-order critical damping element 
  fits the inertia most closely. At the same time, literature models
  often use first order delay blocks to account for inertia. 
  Additionally, higher-order elements require more computational time.
  At the end, your simulation aim will define the required level 
  of detail.
</p>
<p>
  If you do not want to model the inertia at all, just select the option
  NoInertia.
</p>
<p>
  If you find in real data that another approach might be better suited
  (e.g. a deadband), you can extend the model
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.BaseClasses.PartialInertia\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.BaseClasses.PartialInertia
  </a>
  and implement your own approach.
</p>
  
  
<h4>Frosting</h4>

<p>
  To simulate possible icing of the evaporator on air-source devices, the 
  icing factor <code>iceFac</code> is used to influence the outputs. 
  The factor models the reduction of heat transfer between refrigerant 
  and source. Thus, the factor is implemented as follows: 
</p>
<p>
  <code>QEva_flow = iceFac * (QConNoIce_flow - PEle)</code> 
</p>
<p>
  With <code>iceFac</code> as a relative value between 0 and 1: </p>
<p><code>iceFac = kA/kA_noIce</code></p>
<p>Finally, the energy balance must still hold: </p>
<p><code>QCon_flow = PEle + QEva_flow</code> </p>
<p>
  You can select different options for the modeling of the icing factor or
  implement your own approach by extending 
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.BaseClasses.PartialIcingFactor\">
  IBPSA.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.BaseClasses.PartialIcingFactor</a>
</p>
<p>
  Note however, that this only simulated the efficiency reduction 
  due to frosting. If you frosting approach enables the simulation
  of a defrost cycle, you can use an external control model like this one:
  <a href=\"modelica://IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Defrost\">
  IBPSA.Fluid.HeatPumps.ModularReversible.Controls.Safety.Defrost</a> to simulate 
  a reverse cycle defrost and analyze the impact on source 
  and sink temperatures. 
  The <code>iceFac</code> approach was already used in a 
  <a href=\"https://doi.org/10.1016/j.enconman.2021.114888\">contribution</a>
  to account for reverse cycle defrost based on validated literature-data.
  However, as no empirical validation was performed, the model was not
  added to the IBPSA.
</p>

<h4>Heat losses</h4>

<p>
  Most refrigerant cycle models that calculate 
  <code>PEle</code>, <code>QCon_flow</code>, and <code>QEva_flow</code>
  assume the device to be adiabatic, following the equation:
</p>
<p>
  <code>QCon_flow = PEle + QEva_flow</code>
</p>
<p>
  Depending on your application, you may need to model
  the heat losses to the ambient, as those may 
  impact the overall efficiency of the heat pump or chiller.
  Thus, the heat exchangers in the models adds 
  thermal capacities to the adiabatic heat exchanger.
  The parameterization may be challenging, as datasheets 
  do not contain parameters for the required values. 
  Besides empirical calibration, simplified 
  assumptions (e.g. 2 % heat loss) may be used to 
  parameterize the required values.
  For more information, please look at the model 
  description for more info:
  <a href=\"modelica://IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity\">
  IBPSA.Fluid.HeatExchangers.EvaporatorCondenserWithCapacity</a>
</p>
  
<h4>References</h4>
<ul>
<li>F. Wuellhorst et al., A Modular Model of Reversible Heat 
Pumps and Chillers for System Applications, 
https://doi.org/10.3384/ecp21181561
</li>
</ul>

</html>", revisions="<html>
<ul>
<li>
  <i>May 31, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"));

end UsersGuide;