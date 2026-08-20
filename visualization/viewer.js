import * as THREE from 'three';
import { OrbitControls } from 'three/addons/controls/OrbitControls.js';
import { STLLoader } from 'three/addons/loaders/STLLoader.js';

const canvas = document.querySelector('#scene');
const viewer = document.querySelector('.viewer');
const renderer = new THREE.WebGLRenderer({canvas,antialias:true,alpha:true});
renderer.setPixelRatio(Math.min(devicePixelRatio,2));
renderer.outputColorSpace=THREE.SRGBColorSpace;
renderer.toneMapping=THREE.ACESFilmicToneMapping;
renderer.toneMappingExposure=1.15;
renderer.shadowMap.enabled=true;
renderer.shadowMap.type=THREE.PCFSoftShadowMap;

const scene=new THREE.Scene();
scene.fog=new THREE.FogExp2(0x0d1014,.00135);
const camera=new THREE.PerspectiveCamera(32,1,1,2400);
const controls=new OrbitControls(camera,canvas);
controls.enableDamping=true;controls.dampingFactor=.065;controls.target.set(165,92,-77);controls.minDistance=220;controls.maxDistance=1050;
camera.position.set(-300,285,330);

scene.add(new THREE.HemisphereLight(0xd9e7ff,0x241d19,2.2));
const key=new THREE.DirectionalLight(0xffffff,4.0);key.position.set(-250,-260,430);key.castShadow=true;key.shadow.mapSize.set(2048,2048);scene.add(key);
const rim=new THREE.DirectionalLight(0xff6848,2.2);rim.position.set(420,220,160);scene.add(rim);
const floor=new THREE.Mesh(new THREE.PlaneGeometry(1600,1600),new THREE.MeshStandardMaterial({color:0x090b0e,roughness:1}));
floor.rotation.x=-Math.PI/2;floor.position.y=-16;floor.receiveShadow=true;scene.add(floor);
const grid=new THREE.GridHelper(900,36,0x323942,0x1b2026);grid.position.y=-15.5;scene.add(grid);

const root=new THREE.Group();root.rotation.x=-Math.PI/2;scene.add(root);
const stl=new STLLoader();
const material=(color,opts={})=>new THREE.MeshStandardMaterial({color,roughness:opts.roughness??.62,metalness:opts.metalness??.08,transparent:!!opts.opacity,opacity:opts.opacity??1,side:opts.side??THREE.FrontSide});
const mats={shell:material(0x252a30),shell2:material(0x343a42),service:material(0xd84730),dark:material(0x171b20),logo:material(0xf1f3f4,{roughness:.3}),metal:material(0x89919a,{metalness:.72,roughness:.28}),board:material(0x176442,{roughness:.74}),cooler:material(0xf0f2f3,{metalness:.18,roughness:.3}),pipe:material(0xe9edf0,{metalness:.52,roughness:.22}),light:material(0xd9f1ff,{roughness:.16,opacity:.62,side:THREE.DoubleSide}),psu:material(0xc27a31,{metalness:.45,roughness:.35})};
const parts=[];
const T=(position=[0,0,0],matrix=null,center=false)=>({position,matrix,center});
const specs=[
 ['front-core','Передняя половина корпуса','front-core.stl','shell',T(),[-70,0,0]],
 ['rear-core','Задняя половина корпуса','rear-core.stl','shell2',T([165,0,0]),[70,0,0]],
 ['spine-front','Передняя часть каркаса платы','board-spine-front.stl','shell2',T([7,42,17.35]),[-25,-12,0]],
 ['spine-rear','Задняя часть каркаса платы','board-spine-rear.stl','shell2',T([165,42,17.35]),[25,-12,0]],
 ['front-panel','Рабочая передняя сервисная панель','front-panel.stl','service',T([6,15,15],new THREE.Matrix4().set(0,0,-1,0, 1,0,0,0, 0,1,0,0, 0,0,0,1)),[-105,0,0]],
 ['button','Оригинальная монтажная пластина NexGen','button-plate.stl','dark',T([4.55,45.6,147.15],new THREE.Matrix4().set(0,0,-1,0, 1,0,0,0, 0,1,0,0, 0,0,0,1),true),[-125,-15,20]],
 ['button-light','Оригинальный световод кнопки NexGen','button-light-pipe.stl','light',T([0.5,45.6,147.15],new THREE.Matrix4().set(-1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1),true),[-135,-15,20]],
 ['button-bezel','Фасетированный наружный ободок кнопки','button-decorative-bezel.stl','metal',T([0,45.6,147.15]),[-140,-15,20]],
 ['button-cap','Декоративная кнопка NexGen','button-cap-black.stl','dark',T([0,45.6,147.15]),[-145,-15,20]],
 ['button-logo','Светлый логотип кнопки','button-logo-white.stl','logo',T([0,45.6,147.15]),[-146,-15,20]],
 ['front-usb','Передняя кассета Anker A7516 · четыре USB-A','front-usb-cassette.stl','dark',T([2,103.335,90.325],new THREE.Matrix4().set(0,0,-1,0, 1,0,0,0, 0,1,0,0, 0,0,0,1)),[-125,18,0]],
 ['rear-usb','NexGen USB return · задняя панель','usb-cover.stl','dark',T([337,52,95],new THREE.Matrix4().set(1,0,0,0, 0,0,1,0, 0,1,0,0, 0,0,0,1),true),[125,-22,0]],
 ['ssd','Кассета SSD','ssd-cassette.stl','metal',T([22,60,42.5],new THREE.Matrix4().set(0,0,1,0, 0,1,0,0, 1,0,0,0, 0,0,0,1)),[-55,-40,-30]],
 ['esp32-cassette','Боковая кассета ESP32-реле','esp32-cassette.stl','metal',T([180,70,5]),[0,45,-35]],
 ['intake-left','Левая съёмная крышка JF13K · прототип','intake-cover-left.stl','shell2',T([30,151,28],new THREE.Matrix4().set(1,0,0,0, 0,0,1,0, 0,1,0,0, 0,0,0,1)),[0,65,0]],
 ['intake-right','Правая съёмная крышка JF13K · прототип','intake-cover-right.stl','shell',T([165,151,28],new THREE.Matrix4().set(1,0,0,0, 0,0,1,0, 0,1,0,0, 0,0,0,1)),[0,65,0]],
 ['rear-blank-board','Задняя панель I/O','rear-blank-board.stl','dark',T([333,15.35,25.35],new THREE.Matrix4().set(0,0,1,0, 1,0,0,0, 0,1,0,0, 0,0,0,1)),[110,-22,0]],
 ['rear-blank-psu','Задняя панель PSU','rear-blank-psu.stl','shell2',T([333,92.35,25.35],new THREE.Matrix4().set(0,0,1,0, 1,0,0,0, 0,1,0,0, 0,0,0,1)),[110,22,0]],
 ['rear-vertical','Вертикальная задняя крышка / основание','rear-cover-vertical.stl','service',T([330,-15,-15]),[135,0,0]],
 ['rear-horizontal','Горизонтальная задняя крышка','rear-cover-horizontal.stl','service',T([330,0,0]),[110,0,0]],
 ['board','AMD / ASRock BC-250 · локальная mesh-модель','../references/hafriedlander-bc250-case/_extern/bc250_alt.stl','board',T([164.5,52.2,104.35],new THREE.Matrix4().set(0,0,-1,0, -1,0,0,0, 0,1,0,0, 0,0,0,1)),[0,55,0]],
];

function applyTransform(mesh,tr){if(tr.matrix){mesh.applyMatrix4(tr.matrix)}mesh.position.fromArray(tr.position)}
async function loadPart(spec){const [id,label,file,mat,tr,explode]=spec;const url=file.startsWith('../')?file:`assets/${file}`;const geometry=await stl.loadAsync(url);if(tr.center)geometry.center();geometry.computeVertexNormals();const mesh=new THREE.Mesh(geometry,mats[mat]);mesh.castShadow=true;mesh.receiveShadow=true;const group=id==='board'?'board':mat==='service'?'service':'shell';mesh.userData={id,label,group,base:[...tr.position],explode,equipment:id==='board'};applyTransform(mesh,tr);root.add(mesh);parts.push(mesh)}

function box(id,label,size,pos,mat,group){const mesh=new THREE.Mesh(new THREE.BoxGeometry(...size),mats[mat]);mesh.position.set(pos[0]+size[0]/2,pos[1]+size[1]/2,pos[2]+size[2]/2);mesh.castShadow=true;mesh.userData={id,label,group,base:mesh.position.toArray(),explode:[0,55,0],equipment:true};root.add(mesh);parts.push(mesh);return mesh}
function register(mesh,id,label,group,explode=[0,55,0]){mesh.castShadow=true;mesh.receiveShadow=true;mesh.userData={id,label,group,base:mesh.position.toArray(),explode,equipment:true};root.add(mesh);parts.push(mesh);return mesh}
function addBoxPart(id,label,size,center,mat,group){const mesh=new THREE.Mesh(new THREE.BoxGeometry(...size),mats[mat]);mesh.position.fromArray(center);return register(mesh,id,label,group)}
function cooler(){
  addBoxPart('cooler-base','JF13K · основание холодной пластины',[72,9,58],[165,57,93.5],'cooler','cooler');
  addBoxPart('cooler-spreader','JF13K · распределительная пластина',[116,6,84],[165,66,93.5],'cooler','cooler');
  for(let x=47;x<=283;x+=3.2)addBoxPart('cooler-fin','Алюминиевые пластины радиатора',[1.05,30,115],[x,105,93.5],'metal','cooler');
  for(let i=0;i<7;i++){
    const side=i<4?-1:1,index=i<4?i:i-4;
    const curve=new THREE.CatmullRomCurve3([
      new THREE.Vector3(165+(index-1.5)*9,69,93.5+side*9),
      new THREE.Vector3(165+side*(35+index*7),78,93.5+side*(28+index*5)),
      new THREE.Vector3(165+side*(72+index*10),94,93.5+side*(42-index*3))
    ]);
    const pipe=new THREE.Mesh(new THREE.TubeGeometry(curve,24,2.5,8,false),mats.pipe);register(pipe,'heatpipe','JF13K · тепловая трубка','cooler');
  }
  for(const cx of [105,225]){
    const ring=new THREE.Mesh(new THREE.TorusGeometry(54,3.4,10,56),mats.cooler);ring.rotation.x=Math.PI/2;ring.position.set(cx,134,93.5);register(ring,'fan','JF13K · 120 × 15 мм вентилятор','cooler');
    for(const [sx,sz,w,d] of [[cx,36,120,5],[cx,151,120,5],[cx-57,93.5,5,115],[cx+57,93.5,5,115]])addBoxPart('fan-frame','Рама вентилятора',[w,15,d],[sx,134,sz],'cooler','cooler');
    const hub=new THREE.Mesh(new THREE.CylinderGeometry(17,17,15,28),mats.light);hub.position.set(cx,134,93.5);register(hub,'fan-hub','Ступица вентилятора','cooler');
    for(let a=0;a<9;a++){
      const blade=new THREE.Mesh(new THREE.BoxGeometry(38,3.1,10),mats.cooler);const angle=a*Math.PI*2/9+.38;blade.position.set(cx+Math.cos(angle)*25,134,93.5+Math.sin(angle)*25);blade.rotation.y=-angle+.46;register(blade,'fan-blade','Лопасти вентилятора','cooler');
    }
  }
}
function equipment(){box('psu','Cisco UCSC-PSU-650W V02',[240,40,96],[70,6,30],'psu','psu');addBoxPart('usb-hub','Anker A7516 · 103 × 30 × 10 мм',[10,30,103],[7,117.3,125.5],'dark','service');cooler()}

await Promise.all(specs.map(loadPart));equipment();
let rear='vertical',explode=0;
function updateVisibility(){const showShell=document.querySelector('#shell').checked,showEq=document.querySelector('#equipment').checked;for(const p of parts){let visible=p.userData.equipment?showEq:showShell;if(p.userData.id==='rear-vertical')visible=showShell&&rear==='vertical';if(p.userData.id==='rear-horizontal')visible=showShell&&rear==='horizontal';if((p.userData.id==='rear-blank-board'||p.userData.id==='rear-blank-psu'||p.userData.id==='rear-usb'))visible=showShell&&rear!=='none';p.visible=visible}}
function updateExplode(){for(const p of parts){const b=p.userData.base,e=p.userData.explode;p.position.set(b[0]+e[0]*explode,b[1]+e[1]*explode,b[2]+e[2]*explode)}}
document.querySelector('#explode').addEventListener('input',e=>{explode=e.target.value/100;document.querySelector('#explode-value').value=`${e.target.value}%`;updateExplode()});
for(const id of ['shell','equipment'])document.querySelector(`#${id}`).addEventListener('change',updateVisibility);
document.querySelectorAll('[data-rear]').forEach(b=>b.onclick=()=>{rear=b.dataset.rear;document.querySelectorAll('[data-rear]').forEach(x=>x.classList.toggle('active',x===b));updateVisibility()});
document.querySelectorAll('[data-focus]').forEach(b=>b.onclick=()=>{const target=parts.find(p=>p.userData.group===b.dataset.focus&&p.visible);if(target){const wp=new THREE.Vector3();target.getWorldPosition(wp);controls.target.copy(wp);camera.position.copy(wp).add(new THREE.Vector3(-250,210,300))}});
const views={iso:[-300,285,330],front:[-480,92,-77],side:[165,92,520],rear:[740,92,-77]};
document.querySelectorAll('[data-view]').forEach(b=>b.onclick=()=>{camera.position.fromArray(views[b.dataset.view]);controls.target.set(165,92,-77);document.querySelectorAll('[data-view]').forEach(x=>x.classList.toggle('active',x===b));controls.update()});

const raycaster=new THREE.Raycaster(),mouse=new THREE.Vector2(),label=document.querySelector('#part-label');
canvas.addEventListener('pointermove',e=>{const r=canvas.getBoundingClientRect();mouse.set((e.clientX-r.left)/r.width*2-1,-(e.clientY-r.top)/r.height*2+1);raycaster.setFromCamera(mouse,camera);const hit=raycaster.intersectObjects(parts.filter(p=>p.visible),false)[0];if(hit){label.hidden=false;label.textContent=hit.object.userData.label;label.style.left=`${e.clientX-r.left}px`;label.style.top=`${e.clientY-r.top}px`}else label.hidden=true});
canvas.addEventListener('pointerleave',()=>label.hidden=true);

function resize(){const w=viewer.clientWidth,h=viewer.clientHeight;renderer.setSize(w,h,false);camera.aspect=w/h;camera.updateProjectionMatrix()}new ResizeObserver(resize).observe(viewer);resize();updateVisibility();
document.querySelector('.status').classList.add('ready');document.querySelector('#status').textContent=`Готово · ${parts.length} объектов`;
let devVersion=null;
async function checkForUpdates(){
  try{
    const response=await fetch(`/__viewer_status?t=${Date.now()}`,{cache:'no-store'});
    if(!response.ok)return;
    const next=await response.json();
    if(devVersion===null)devVersion=next.version;
    else if(next.version!==devVersion)location.reload();
    if(next.building)document.querySelector('#status').textContent='OpenSCAD: пересборка…';
    else if(next.error)document.querySelector('#status').textContent=`Ошибка сборки: ${next.error}`;
  }catch{/* Plain static servers do not provide live reload. */}
}
setInterval(checkForUpdates,1000);checkForUpdates();
function animate(){requestAnimationFrame(animate);controls.autoRotate=document.querySelector('#rotate').checked;controls.autoRotateSpeed=.75;controls.update();renderer.render(scene,camera)}animate();
