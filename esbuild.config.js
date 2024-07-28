#!/usr/bin/env node

const path = require('path')
const rails = require('esbuild-rails')

require('esbuild').build({
    entryPoints: ["application.js"],
    bundle: true,
    outdir: path.join(process.cwd(), "app/assets/builds"),
    absWorkingDir: path.join(process.cwd(), "app/javascript"),
    watch: process.argv.includes("--watch"),
    loader: {'.svg': 'text'},
    plugins: [rails()]
}).then(console.log("watch js files")).catch(() => process.exit(1))
