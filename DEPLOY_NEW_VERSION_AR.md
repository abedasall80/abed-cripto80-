# نشر الإصدار الجديد 3.2 — دليل مختصر

## ما الذي تم تجهيزه؟
- واجهة الموقع وأصولها داخل Worker واحد.
- مسارات `/health` و`/diagnostics` تُعالج داخل Worker بدل أن تعود 404 من الملفات الثابتة.
- اسم Worker مضبوط على `spring-hall-fc73` حتى يكون النشر على العنوان الحالي نفسه.
- إعداد `render.yaml` لتسهيل نشر محرك Python بصورة مستقلة على Render.
- لا توجد مفاتيح API سرية داخل ملفات الواجهة.

## مهم جدًا
لا يمكن أن أنشر داخل حساب Cloudflare أو Render من هذه البيئة من دون تفويض دخول من صاحب الحساب. الملفات جاهزة، لكن النشر الخارجي يحتاج موافقة الحساب.

## أولا: نشر محرك Python
1. ارفع مجلد المشروع إلى مستودع GitHub خاص بك.
2. في Render اختر New > Blueprint واربط المستودع الذي يحتوي `render.yaml`.
3. انشر خدمة Python وانتظر أن تصبح Live.
4. افتح رابط الخدمة متبوعًا بـ `/health`، ويجب أن تظهر JSON فيها `status: ok`.

## ثانيًا: إعداد Worker
1. افتح Cloudflare Workers & Pages ثم العامل `spring-hall-fc73`.
2. من Settings > Variables and Secrets أضف متغيرًا غير سري اسمه `PYTHON_API_ORIGIN`، وقيمته أصل رابط Render فقط، مثل `https://اسم-الخدمة.onrender.com` من دون `/api` أو `/health`.
3. من جهازك، بعد تثبيت Node.js، افتح مجلد `worker` في الطرفية ونفّذ:
   - `npm install`
   - `npx wrangler login`
   - `npx wrangler deploy`
4. افتح `https://spring-hall-fc73.3bdmn3m3sl.workers.dev/health` ويجب أن ترى `version: 3.2.0`.
5. افتح `https://spring-hall-fc73.3bdmn3m3sl.workers.dev/api/status` لاختبار اتصال Python.

## اختبار محلي سريع
داخل `python_engine`:
- `python -m pip install -r requirements.txt`
- `uvicorn app:app --host 127.0.0.1 --port 8000`
- افتح `http://127.0.0.1:8000/health`

## السلامة والدقة
هذا التطبيق لتحليل البيانات التاريخية/العامة فقط ولا يضمن الأرباح أو نجاح الإشارات. لا تضع أي رموز سرية في `site/` أو `site/config.js`.
