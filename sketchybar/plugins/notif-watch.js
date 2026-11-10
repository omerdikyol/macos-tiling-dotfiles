// Watches macOS Notification Center banners through accessibility and prints one line per new banner:
// N<TAB>banner|alert<TAB>title<TAB>rest-of-text
// Banners (no buttons) are moved off-screen. Alerts with buttons are left alone so they stay answerable.
ObjC.import('Foundation');
const nc = Application('System Events').processes.byName('NotificationCenter');
const out = s => $.NSFileHandle.fileHandleWithStandardOutput.writeData($(s + '\n').dataUsingEncoding($.NSUTF8StringEncoding));
const clean = s => String(s).replace(/[\t\r\n]+/g, ' ').trim();
let last = '';
while (true) {
  try {
    if (nc.windows.length > 0) {
      const w = nc.windows[0], texts = []; let buttons = 0;
      const walk = (e, d) => { if (d > 7) return; for (const c of e.uiElements()) {
        const r = c.role();
        if (r === 'AXStaticText') { try { texts.push(clean(c.value())); } catch (x) {} }
        else if (r === 'AXButton') buttons++;
        walk(c, d + 1); } };
      walk(w, 0);
      const t = texts.filter(Boolean);
      if (t.length) {
        if (buttons === 0) { try { w.position = [-4000, 100]; } catch (x) {} }
        const key = t.join('|');
        if (key !== last) { last = key; out(['N', buttons > 0 ? 'alert' : 'banner', t[0], t.slice(1).join(' - ')].join('\t')); }
      }
    } else last = '';
  } catch (e) {}
  $.NSThread.sleepForTimeInterval(0.4);
}
