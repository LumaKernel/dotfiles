function node_use_port
  node -e "[3000,8000].forEach(async(p)=>{try{await new Promise((rs,rj)=>require('http').createServer().listen(p,void 0,rs).on('error',rj));console.log(`\${p}: listening`)}catch{console.log(`\${p}: already used`)}})"
end
