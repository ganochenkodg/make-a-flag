<script>
	import {
		onMount
	} from "svelte";

	let fileinput, imageSrc = 'doge.jpg',
		canvasPadding, size;
	let gradient = ",white 50%, red 50%"

	onMount(() => {
		canvasPadding = 200;
		if (window.innerWidth < 600 || window.innerHeight < 600) {
			canvasPadding = 80;
		}
		size = window.innerWidth < window.innerHeight ? window.innerWidth - canvasPadding : window.innerHeight - canvasPadding;
	});

	function onFileSelected(e) {
		let image = e.target.files[0];
		let reader = new FileReader();
		reader.addEventListener("load", () => {
			imageSrc = reader.result
			getPalette(reader.result)
		}, false);
		if (image) {
			reader.readAsDataURL(image)
		}
	}

	function getPalette(imageSrc) {
		Vibrant.from(imageSrc).maxColorCount(200).getPalette().then((palette) => {
			gradient = ""
			const colors = []
			for (let color in palette) {
				const hex = palette[color].getHex()
				colors.push(hex)
			}
			colors.forEach(function(value, i) {
				gradient = gradient + "," + value + " " + Math.round(100 * i / colors.length) + "% " + Math.round(100 * (i + 1) / colors.length) + "%";
			});
		});
	}
</script>

<style>
	canvas {
		display: block;
		outline: 1px solid #999;
		box-shadow: 1px 10px 15px #888888;
		margin: 20px auto;
	}

	.imageSrc {
		display: block;
		outline: 1px solid #999;
		border: solid black 1px;
		background-color: #ffffff;
		height: auto;
		max-height: 300px;
		box-shadow: 1px 10px 15px #888888;
		margin: 20px auto;
		object-fit: cover;
	}

	b {
		font-size: 16px;
		text-align: center;
		display: block;
		color: rgba(0, 0, 0, 0.8);
		text-shadow: 2px 8px 6px rgba(0, 0, 0, 0.2),
			0px -5px 35px rgba(255, 255, 255, 0.3);
	}

	:global(body) {
		margin: 0;
		background-color: #f8f8f8;
		background-image: url("data:image/svg+xml,%3Csvg width='42' height='44' viewBox='0 0 42 44' xmlns='http://www.w3.org/2000/svg'%3E%3Cg id='Page-1' fill='none' fill-rule='evenodd'%3E%3Cg id='brick-wall' fill='%23e7e4eb' fill-opacity='0.4'%3E%3Cpath d='M0 0h42v44H0V0zm1 1h40v20H1V1zM0 23h20v20H0V23zm22 0h20v20H22V23z'/%3E%3C/g%3E%3C/g%3E%3C/svg%3E");
	}
</style>

<svelte:head>
	<script src="vibrant.min.js" on:load={getPalette(imageSrc)}></script>
</svelte:head>

<div>
	<b>↓ Click on the picture below to upload your own ↓</b>
	<img class="imageSrc" style="width: {size}px;" src="{imageSrc}" alt="Click me" on:click={()=>{fileinput.click();}}/>
	<input style="display:none" type="file" accept=".jpg, .jpeg, .png" on:change={(e)=>onFileSelected(e)} bind:this={fileinput} >
	<canvas style="border: solid black 1px;height: {size * 0.5}px; width: {size}px;background: linear-gradient(to bottom {gradient});"></canvas>
</div>
