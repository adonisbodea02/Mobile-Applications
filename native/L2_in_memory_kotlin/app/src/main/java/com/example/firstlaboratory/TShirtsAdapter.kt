package com.example.firstlaboratory

import android.app.AlertDialog
import android.content.Context
import android.text.InputType
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.recyclerview.widget.RecyclerView
import com.example.firstlaboratory.models.TShirt
import com.example.firstlaboratory.service.Service
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import kotlinx.android.synthetic.main.recyclerview_item.view.*
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

class TShirtsAdapter(val context: Context) :
    RecyclerView.Adapter<TShirtsAdapter.TShirtViewHolder>() {

    private var ts: ArrayList<TShirt> = ArrayList()

    private var tShirtViewModel: TShirtViewModel? = null


    class TShirtViewHolder(view: View) : RecyclerView.ViewHolder(view)

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): TShirtViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.recyclerview_item, parent, false)

        return TShirtViewHolder(view)
    }

    override fun getItemCount(): Int {
        return ts.size
    }

    override fun onBindViewHolder(holder: TShirtViewHolder, position: Int) {
        holder.itemView.name.text = ts[position].band + " " + ts[position].color + " " + ts[position].size
        holder.itemView.btnDelete.setOnClickListener {
            if (isNetworkConnected(context)){
                showDeleteDialog(holder, ts[position])
            }
            else{
                Toast.makeText(context,"Delete operation is not available offline!", Toast.LENGTH_SHORT).show()
            }
        }

        holder.itemView.btnEdit.setOnClickListener {
            if (isNetworkConnected(context)){
                showUpdateDialog(holder, ts[position])
            }
            else{
                Toast.makeText(context,"Update operation is not available offline!", Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun showUpdateDialog(holder: TShirtViewHolder, t: TShirt) {
        val dialogBuilder = AlertDialog.Builder(holder.itemView.context)


        val bandLayout = TextInputLayout(holder.itemView.context)
        val colorLayout = TextInputLayout(holder.itemView.context)
        val sizeLayout = TextInputLayout(holder.itemView.context)
        val priceLayout = TextInputLayout(holder.itemView.context)
        val currencyLayout = TextInputLayout(holder.itemView.context)

        val bandEditText = TextInputEditText(holder.itemView.context)
        val colorEditText = TextInputEditText(holder.itemView.context)
        val sizeEditText = TextInputEditText(holder.itemView.context)
        val priceEditText = TextInputEditText(holder.itemView.context)
        val currencyEditText = TextInputEditText(holder.itemView.context)
        priceEditText.inputType = InputType.TYPE_CLASS_PHONE

        bandEditText.hint = "Band"
        colorEditText.hint = "Color"
        sizeEditText.hint = "Size"
        priceEditText.hint = "Price"
        currencyEditText.hint = "Currency"

        bandEditText.setText(t.band)
        colorEditText.setText(t.color)
        sizeEditText.setText(t.size)
        priceEditText.setText(t.price.toString())
        currencyEditText.setText(t.currency)

        bandLayout.addView(bandEditText)
        colorLayout.addView(colorEditText)
        sizeLayout.addView(sizeEditText)
        priceLayout.addView(priceEditText)
        currencyLayout.addView(currencyEditText)

        val lp = LinearLayout(holder.itemView.context)
        lp.orientation = LinearLayout.VERTICAL

        lp.addView(bandLayout)
        lp.addView(colorLayout)
        lp.addView(sizeLayout)
        lp.addView(priceLayout)
        lp.addView(currencyLayout)

        dialogBuilder.setView(lp)

        dialogBuilder.setTitle("Update TShirt")
        dialogBuilder.setPositiveButton("Update") { _, _ ->
            updateTShirt(
                TShirt(
                    bandEditText.text.toString(),
                    colorEditText.text.toString(),
                    sizeEditText.text.toString(),
                    priceEditText.text.toString().toInt(),
                    currencyEditText.text.toString(),
                    t.id
                )
            )
        }
        dialogBuilder.setNegativeButton("Cancel") { dialog, _ ->
            dialog.cancel()
        }
        val b = dialogBuilder.create()
        b.show()
    }

    private fun showDeleteDialog(holder: TShirtViewHolder, t: TShirt) {
        val dialogBuilder = AlertDialog.Builder(holder.itemView.context)
        dialogBuilder.setTitle("Delete")
        dialogBuilder.setMessage("Confirm delete?")
        dialogBuilder.setPositiveButton("Delete") { _, _ ->
            deleteTShirt(t)
        }
        dialogBuilder.setNegativeButton("Cancel") { dialog, _ ->
            dialog.cancel()
        }
        val b = dialogBuilder.create()
        b.show()
    }


    private fun updateTShirt(t: TShirt) {
        GlobalScope.launch {
            val tServer = Service.service.update(t.id.toString(), t)
            tShirtViewModel?.update(tServer)
        }
        notifyDataSetChanged()
    }

    private fun deleteTShirt(t: TShirt) {
        GlobalScope.launch {
            Service.service.delete(t.id.toString())
            tShirtViewModel?.delete(t.id)
        }
    }

    fun setTShirts(tsList: ArrayList<TShirt>) {
        this.ts = tsList
        notifyDataSetChanged()
    }

    fun setViewModel(tViewModel: TShirtViewModel) {
        this.tShirtViewModel = tViewModel
    }
}