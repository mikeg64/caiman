<?php 
//These dirs are used while on the local computer
//$webpageRootDir="http://".$_SERVER['HTTP_HOST']."/~creyes";
//$caimanRootDir="http://".$_SERVER['HTTP_HOST']."/~creyes/caiman";
//These dirs are used on the webpage
$webpageRootDir="http://".$_SERVER['HTTP_HOST']."";
$caimanRootDir="http://".$_SERVER['HTTP_HOST']."/caiman";

 ?>

<td id="localNavigationContainer">
	
<div id="localNavigation"><ul>

<li>
     <a href="<?php echo ($webpageRootDir.'/index.php'); ?>" > CAIMAN   </a>
     <ul>
     	<li> <a href=<?php echo $caimanRootDir."/migration.php";?>> Migration Measurement</a> </li>
     	<li> <a href=<?php echo $caimanRootDir."/vesselT.php";?>> Tracing Vessels</a> </li>  
    	<li> <a href=<?php echo ($caimanRootDir."/shading.php"); ?> > Shading Correction</a> </li>
    	<li> <a href=<?php echo ($caimanRootDir."/chromat.php"); ?> > Chromatic Analysis</a> </li>
    	<!-- <li> <a href=<?php echo ($caimanRootDir."/QuantifHeart.php"); ?> > Quantification of Sprouts</a> </li>  -->
     	<li> <a href=<?php echo $caimanRootDir."/segment.php";?>> Segmentation of Endothelial Cells</a> </li>  
     	<!-- <li> <a href=<?php echo $caimanRootDir."/mergeRGB.php";?>> RGB Layer Merge</a> </li>                    -->
     	<!-- <li> <a href=<?php echo ($caimanRootDir."/register.php"); ?> > -> Registration <- </a> </li>            -->
     	<!-- <li> <a href=<?php echo $caimanRootDir."/permeability.php";?>> Estimation of Permeability</a> </li>     -->
      </ul>
</li>
<li >
      <a href=<?php echo ($caimanRootDir."/register.php"); ?> > Registration  </a> 
</li> 
<li >
      <a href=<?php echo ($caimanRootDir."/caimanFAQ.php"); ?> > Frequently Asked Questions </a> 
</li> 
<li >
      <a href=<?php echo ($caimanRootDir."/caimanLinks.php"); ?> > Links </a> 
</li> 

</ul>
</div>

</td>

<!-- // local navigation -->
<!--    	<li> <a href="caiman.php?idRes=shading"> Shading Correction</a> </li>
     	<li> <a href="caiman.php?idRes=permeability"> Estimation of Permeability</a> </li>
     	<li> <a href="caiman.php?idRes=migration"> Migration Measurement</a> </li>
 
-->