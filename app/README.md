# SMR ENVYDO No Gas – Scheme Adjustment V8

## Scheme Adjustment changes
- Removed the old **ENVY Product** selector.
- Added the **17 ENVY categories** from the supplied paper as a dropdown.
- Added all 17 categories to the scheme table.
- Removed **Margin** completely from the scheme adjustment page and scheme data.
- Scheme Slab 1/2/3 and Trade Promotion values are seeded from the supplied paper.
- Admin can edit Trade Promotion %, Slab % and CS thresholds for each category.
- Primary Order scheme calculation reads the category rule for the selected ENVY product, so changing a category scheme changes the discount/net price calculation automatically.
- MRP and Rate remain locked.
- CS means Case Quantity.
- Below Slab 1, Trade Promotion is applied; eligible slab is selected by CS threshold.

## Run
```bash
pip install -r requirements.txt
python app.py
```

Set `FLASK_SECRET_KEY` to a securely generated value in deployed environments
so sessions remain valid across restarts. Without it, the app uses a random
per-process key and existing sessions are invalidated when the process restarts.

## V9 Primary Order scheme logic
- ENVY Primary Order quantity is entered in pieces.
- Product `case_size` converts pieces to CS (`CS = quantity / case_size`).
- Scheme Adjustment slab thresholds are compared against CS.
- Below the first configured slab, Trade Promotion applies.
- The highest eligible slab applies automatically.
- ENVY Scheme is read-only for users; only Admin edits Scheme Adjustment rules.
- Example for a 60-piece case with 34% on 2 CS, 36% on 5 CS, 37% on 10 CS: 60 pcs -> Trade Promotion, 120 pcs -> 34%, 300 pcs -> 36%, 600 pcs -> 37%.

## Perfume catalogue update
- Replaced the two old sample Perfume products with the 16 products from the supplied catalogue image.
- Added GM/ML, MRP, Case Size and Rate exactly from the supplied image.
- Perfume Primary Order quantities use 6-piece increments: 6, 12, 18, 24...
- Perfume schemes are admin-controlled and automatically selected by CS using the existing ENVY scheme rules: Trade Promotion below Slab 1, then the highest eligible slab.
- 30ML/100ML: 43% on 1 CS; 60ML/50ML: 43% on 1 CS, 46% on 5 CS, 48% on 10 CS.
- Primary Order users cannot edit the scheme.

## ENVY category update
- The correct brand spelling is **ENVY**. Legacy `NV` brand records are migrated to `ENVY` automatically.
- **Pocket** is an ENVY category containing the 3 supplied 18ML Pocket products.
- **French Collection** is an ENVY category containing the 5 supplied 99GM/120ML products.
- Pocket uses the Admin scheme category `Envy Pocket Perfume 18ml` and 6-piece quantity increments.
- French Collection uses the Admin scheme category `Envy Deo (FRENCH COLLECTION)` and 12-piece quantity increments.
- Product pages show ENVY → category tabs, and Primary Order reads the Admin-controlled scheme from case quantity.


## SMR / SS Backup Data
The Admin sidebar now includes `SMR & Backup Data`. It keeps the SMR workbook and the three SS backup workbooks in separate `data_files` folders. Uploading a new workbook replaces the previous workbook in that same section; the file can be downloaded and edited in Excel.
