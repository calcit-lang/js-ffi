import assert from 'node:assert/strict';
import {execFileSync} from 'node:child_process';
import {writeFileSync} from 'node:fs';
const run=(...args)=>execFileSync('calcit',args,{encoding:'utf8',stdio:['ignore','pipe','pipe'],maxBuffer:8*1024*1024});
const q=id=>JSON.parse(run('query','def',id,'--format','json')).data;
assert.equal(run('-v').trim(),'0.30.1');
const ns='js-ffi.browser/';
const element=q(ns+'DomElementHost'),main=q('js-ffi.browser-test/main!');
const setters=['element-set-value!','element-set-placeholder!'].map(n=>q(ns+n));
const fields=[':value',':placeholder'];
assert.deepEqual(element.code.filter(x=>Array.isArray(x)&&fields.includes(x[0])).map(x=>x[0]),fields);
const common=element.code.filter(x=>!Array.isArray(x)||!fields.includes(x[0]));
const metadata=structuredClone(element.ffi);
for(const f of fields)delete metadata[':names'][f];
metadata[':writable'].__edn_set=metadata[':writable'].__edn_set.filter(x=>!fields.includes(':'+x.__edn_tag));
// Encode only the structured FFI map obtained from the official query, not Snapshot text.
const serialize=x=>{
  if(typeof x==='string')return JSON.stringify('|'+x);
  if(x.__edn_tag)return ':'+x.__edn_tag;
  if(x.__edn_set)return '#{} '+x.__edn_set.map(serialize).join(' ');
  return '{} '+Object.entries(x).map(([k,v])=>{
    const text=serialize(v),container=typeof v==='object'&&!v.__edn_tag;
    return `(${k} ${container?'('+text+')':text})`;
  }).join(' ');
};
const operations=[];
const def=(id,code,overwrite=false)=>operations.push(['edit','def',id,...(overwrite?['--overwrite']:[]),'--input-format','json-ast','--code',JSON.stringify(code)]);
const schema=(id,code)=>operations.push(['edit','schema',id,'--input-format','json-ast','--code',JSON.stringify(code)]);
def(ns+'DomElementHost',common,true);
operations.push(['edit','ffi',ns+'DomElementHost','--code',serialize(metadata)]);
for(const [name,field] of [['DomValueHost',':value'],['DomPlaceholderHost',':placeholder']]){
  def(ns+name,['deftrait',name,[field,"'String"]]);
  schema(ns+name,"'Trait");
  operations.push(['edit','ffi',ns+name,'--code',`{} (:backend :js) (:kind :external-object) (:target :browser) (:writable $ #{} ${field})`]);
  operations.push(['edit','tags',ns+name,'ffi,js-host']);
}
for(const [index,trait,field,arg] of [[0,'DomValueHost',':value','value'],[1,'DomPlaceholderHost',':placeholder','text']]){
  const old=setters[index];
  assert.deepEqual(old.code.slice(0,3),['defn',old.code[1],['element',arg]]);
  def(old.id,['defn',old.code[1],['element',arg],['let',[['host',['js-cast','element',"'"+ns+trait]]],['js-set','host',field,arg],'&unit']],true);
}
const fixture='js-ffi.browser-test/cast-element-host';
def(fixture,['defn','cast-element-host',['value'],['js-cast','value',"'"+ns+'DomElementHost']]);
schema(fixture,['::',"'Fn",['{}',[':args',['[]',"'JsObject"]],[':return',"'"+ns+'DomElementHost'],[':features',['#{}',':js-ffi']]]]);
const mainCode=structuredClone(main.code);mainCode.splice(3,0,'cast-element-host');
def(main.id,mainCode,true);
writeFileSync('acceptance/operations.json',JSON.stringify(operations,null,2));
writeFileSync('acceptance/before.json',JSON.stringify({element,setters,main},null,2));
const args=['edit','transaction','--file','acceptance/operations.json','--format','json'];
const preview=JSON.parse(run(...args,'--dry-run'));
writeFileSync('acceptance/preview.json',JSON.stringify(preview,null,2));
writeFileSync('acceptance/applied.json',run(...args,'--expect-revision',preview.scoped_revision));
const after=q(ns+'DomElementHost');
assert.deepEqual(after,{...element,code:common,ffi:metadata,ffi_edn:after.ffi_edn});
for(const old of setters)assert.deepEqual(q(old.id).schema,old.schema,'public setter API stays unchanged');
writeFileSync('acceptance/after.json',JSON.stringify({element:after,setters:setters.map(x=>q(x.id)),fixture:q(fixture)},null,2));
writeFileSync('acceptance/program-diff.json',run('analyze','program-diff','HEAD','--format','json'));
