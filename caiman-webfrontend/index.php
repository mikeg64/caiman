<?php require("head.ece"); ?>
<?php require("topCaiman.ece"); ?>



  


<!-- Local Content -->


<table id="contentContainer" summary="content layout table" cellpadding="0" cellspacing="0" border="0">

<tr>

<?php require("menuNavC.php"); ?>

<!-- // local navigation -->

  <td id="bodyContainer">
 

<?php 
// $webpageRootDir="http://".$_SERVER['HTTP_HOST']."/~creyes";
// require ($webpageRootDir.'/caiman/caiman.ece'); 
  require('caiman/docs/caiman.ece');
//read variables passed from previous webpage
/*  $idRes  = $_GET["idRes"];


if     ($idRes==permeability) {  require($caimanRootDir."/permeability.ece"); }		
elseif ($idRes==migration)    {  require($caimanRootDir."/migration.ece");    }		
elseif ($idRes==shading)      {  require($caimanRootDir."/shading.php");      }	
else                          {  require($caimanRootDir.'/caiman.ece');     }
*/

?>
</tr>
</table>



</div>
<!-- // Local Content -->


<!-- footer start -->

<?php require("foot.html"); ?>
