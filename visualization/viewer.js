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
const assetVersion=Date.now();
const material=(color,opts={})=>new THREE.MeshStandardMaterial({color,roughness:opts.roughness??.62,metalness:opts.metalness??.08,transparent:!!opts.opacity,opacity:opts.opacity??1,side:opts.side??THREE.FrontSide});
const mats={shell:material(0x252a30),shell2:material(0x434b55),intake:material(0xaeb9c5,{roughness:.48}),service:material(0xd84730),dark:material(0x171b20),logo:material(0xf1f3f4,{roughness:.3}),metal:material(0x89919a,{metalness:.72,roughness:.28}),board:material(0x20a568,{roughness:.74}),cooler:material(0xe8edf2,{metalness:.18,roughness:.3}),pipe:material(0xbcc6ce,{metalness:.52,roughness:.22}),light:material(0xd9f1ff,{roughness:.16,opacity:.62,side:THREE.DoubleSide}),psu:material(0xe88924,{metalness:.45,roughness:.35}),button:material(0xf0c642,{metalness:.35,roughness:.3}),anker:material(0x2f79d0,{metalness:.3,roughness:.35}),rearUsb:material(0xe35ca0,{metalness:.2,roughness:.4}),ssd:material(0x9b6de3,{metalness:.45,roughness:.3}),esp32:material(0x24bfd0,{metalness:.2,roughness:.42})};
const parts=[];
const T=(position=[0,0,0],matrix=null,center=false)=>({position,matrix,center});
const specs=[
 ['front-core','Передняя половина корпуса','front-core.stl','shell',T(),[-70,0,0]],
 ['rear-core','Задняя половина корпуса','rear-core.stl','shell2',T([165,0,0]),[70,0,0]],
 ['front-panel','Фигурная торцевая панель Nyacom · 4×M3','front-panel.stl','service',T([0,0,0],new THREE.Matrix4().set(0,0,-1,0, 1,0,0,0, 0,1,0,0, 0,0,0,1)),[-105,0,0]],
 ['front-usb','Кассета фронтального USB-хаба','front-usb-cassette.stl','dark',T([-12,111.335,87.325],new THREE.Matrix4().set(0,0,-1,0, 1,0,0,0, 0,1,0,0, 0,0,0,1)),[-115,20,0]],
 ['spine-front','Передняя часть каркаса платы','board-spine-front.stl','shell2',T([7,42,17.35]),[-25,-12,0]],
 ['spine-rear','Задняя часть каркаса платы','board-spine-rear.stl','shell2',T([165,42,17.35]),[25,-12,0]],
 ['button','Внутренняя монтажная пластина NexGen','button-plate.stl','button',T([5.1,37.6,164.15],new THREE.Matrix4().set(0,0,-1,0, 1,0,0,0, 0,1,0,0, 0,0,0,1),true),[-125,-15,20]],
 ['button-light','Световод кнопки NexGen','button-light-pipe.stl','light',T([-12.5,37.6,164.15],new THREE.Matrix4().set(-1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1),true),[-135,-15,20]],
 ['button-bezel','Фасетированный наружный ободок кнопки','button-decorative-bezel.stl','button',T([-12.7,37.6,164.15]),[-140,-15,20]],
 ['button-cap','Декоративная кнопка NexGen','button-cap-black.stl','button',T([-12.8,37.6,164.15]),[-145,-15,20]],
 ['button-logo','Светлый логотип кнопки','button-logo-white.stl','logo',T([-12.9,37.6,164.15]),[-146,-15,20]],
 ['rear-usb','NexGen USB return · задняя панель','usb-cover.stl','rearUsb',T([337,52,95],new THREE.Matrix4().set(1,0,0,0, 0,0,1,0, 0,1,0,0, 0,0,0,1),true),[125,-22,0]],
 ['ssd','Кассета SSD','ssd-cassette.stl','ssd',T([22,60,42.5],new THREE.Matrix4().set(0,0,1,0, 0,1,0,0, 1,0,0,0, 0,0,0,1)),[-55,-40,-30]],
 ['esp32-cassette','Боковая кассета ESP32-реле','esp32-cassette.stl','esp32',T([180,62,5]),[0,45,-35]],
 ['esp32-cover','Крышка отсека ESP32 · заподлицо','esp32-cover.stl','shell2',T([165,151,0],new THREE.Matrix4().set(1,0,0,0, 0,0,1,0, 0,1,0,0, 0,0,0,1)),[0,70,-35]],
 ['intake-left','Левая съёмная крышка JF13K · прототип','intake-cover-left.stl','intake',T([30,151,32],new THREE.Matrix4().set(1,0,0,0, 0,0,1,0, 0,1,0,0, 0,0,0,1)),[0,65,0]],
 ['intake-right','Правая съёмная крышка JF13K · прототип','intake-cover-right.stl','intake',T([170,151,32],new THREE.Matrix4().set(1,0,0,0, 0,0,1,0, 0,1,0,0, 0,0,0,1)),[0,65,0]],
 ['rear-vertical','Вертикальная задняя крышка / основание','rear-cover-vertical.stl','service',T([330,-15,-15]),[135,0,0]],
 ['rear-horizontal','Горизонтальная задняя крышка','rear-cover-horizontal.stl','service',T([330,0,0]),[110,0,0]],
 ['board','AMD / ASRock BC-250 · локальная mesh-модель','../references/hafriedlander-bc250-case/_extern/bc250_alt.stl','board',T([164.5,52.2,104.35],new THREE.Matrix4().set(0,0,-1,0, -1,0,0,0, 0,1,0,0, 0,0,0,1)),[0,55,0]],
];

function applyTransform(mesh,tr){if(tr.matrix){mesh.applyMatrix4(tr.matrix)}mesh.position.fromArray(tr.position)}
function componentFor(id){if(id==='front-panel')return'frontCover';if(id==='esp32-cover')return'shell';if(id==='rear-vertical'||id==='rear-horizontal')return'rearCover';if(id==='rear-usb')return'rearUsb';if(id.startsWith('button'))return'button';if(id==='ssd')return'ssd';if(id.startsWith('esp32'))return'esp32';if(id==='board')return'board';return'shell'}
async function loadPart(spec){const [id,label,file,mat,tr,explode]=spec;const source=file.startsWith('../')?file:`assets/${file}`;const url=`${source}?v=${assetVersion}`;const geometry=await stl.loadAsync(url);if(tr.center)geometry.center();geometry.computeVertexNormals();const mesh=new THREE.Mesh(geometry,mats[mat]);mesh.castShadow=true;mesh.receiveShadow=true;const group=componentFor(id);const equipment=!['shell','frontCover','rearCover'].includes(group);mesh.userData={id,label,group,base:[...tr.position],explode,equipment,enabled:true};applyTransform(mesh,tr);root.add(mesh);parts.push(mesh)}

function box(id,label,size,pos,mat,group){const mesh=new THREE.Mesh(new THREE.BoxGeometry(...size),mats[mat]);mesh.position.set(pos[0]+size[0]/2,pos[1]+size[1]/2,pos[2]+size[2]/2);mesh.castShadow=true;mesh.userData={id,label,group,base:mesh.position.toArray(),explode:[0,55,0],equipment:true,enabled:true};root.add(mesh);parts.push(mesh);return mesh}
function register(mesh,id,label,group,explode=[0,55,0]){mesh.castShadow=true;mesh.receiveShadow=true;mesh.userData={id,label,group,base:mesh.position.toArray(),explode,equipment:true,enabled:true};root.add(mesh);parts.push(mesh);return mesh}
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
function ankerHub(){
  // A7516 body is 103 × 30 × 10 mm. It is rotated so the long port edge is
  // vertical and the 30 mm body width extends inward along +X.
  addBoxPart('anker-body','Anker A7516 · корпус 103 × 30 × 10 мм',[30,10,103],[15,117.3,128.5],'anker','anker');
  addBoxPart('anker-edge','Anker A7516 · лицевая грань с портами',[2.2,10.6,70.35],[-1.1,117.3,128.5],'anker','anker');
  for(let i=0;i<4;i++){
    const z=103.9+i*16.4;
    addBoxPart('anker-port','Anker A7516 · USB-A 3.0',[1.6,8.2,15],[-2.2,117.3,z],'dark','anker');
    addBoxPart('anker-port-blue','USB 3.0 insert',[1.8,6.6,12.6],[-3.05,117.3,z],'anker','anker');
  }
  addBoxPart('anker-led','Anker A7516 · индикатор',[1.9,1.5,3],[-3.1,117.3,103.3],'light','anker');
}
function equipment(){box('psu','Cisco UCSC-PSU-650W V02',[240,40,96],[70,6,30],'psu','psu');ankerHub();cooler()}

await Promise.all(specs.map(loadPart));equipment();
let rear='horizontal',explode=0;
function updateLegend(){document.querySelectorAll('#component-legend button').forEach(button=>{const matches=parts.filter(p=>p.userData.id===button.dataset.partId);const present=matches.length>0,visible=matches.some(p=>p.visible);button.classList.toggle('missing',!present);button.classList.toggle('off',present&&!visible);button.querySelector('small').textContent=!present?'нет':visible?'виден':'скрыт'})}
function updateVisibility(){const showShell=document.querySelector('#shell').checked,showEq=document.querySelector('#equipment').checked;for(const p of parts){let visible=(p.userData.equipment?showEq:showShell)&&p.userData.enabled;if(p.userData.id==='rear-vertical')visible=showShell&&rear==='vertical'&&p.userData.enabled;if(p.userData.id==='rear-horizontal')visible=showShell&&rear==='horizontal'&&p.userData.enabled;if(p.userData.id==='rear-usb')visible=showShell&&rear!=='none'&&p.userData.enabled;p.visible=visible}updateLegend()}
function buildLegend(){const host=document.querySelector('#component-legend');const entries=new Map();for(const part of parts)if(!entries.has(part.userData.id))entries.set(part.userData.id,part);for(const [id,part] of entries){const button=document.createElement('button');button.type='button';button.dataset.partId=id;const color=`#${part.material.color.getHexString()}`;button.innerHTML=`<b style="--swatch:${color}"></b><span>${part.userData.label}</span><small></small>`;button.onclick=()=>{const matches=parts.filter(p=>p.userData.id===id);const enable=!matches.some(p=>p.userData.enabled);matches.forEach(p=>p.userData.enabled=enable);updateVisibility()};host.append(button)}}
buildLegend();
function updateExplode(){for(const p of parts){const b=p.userData.base,e=p.userData.explode;p.position.set(b[0]+e[0]*explode,b[1]+e[1]*explode,b[2]+e[2]*explode)}}
document.querySelector('#explode').addEventListener('input',e=>{explode=e.target.value/100;document.querySelector('#explode-value').value=`${e.target.value}%`;updateExplode()});
for(const id of ['shell','equipment'])document.querySelector(`#${id}`).addEventListener('change',updateVisibility);
document.querySelectorAll('[data-rear]').forEach(b=>b.onclick=()=>{rear=b.dataset.rear;document.querySelectorAll('[data-rear]').forEach(x=>x.classList.toggle('active',x===b));updateVisibility()});
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
