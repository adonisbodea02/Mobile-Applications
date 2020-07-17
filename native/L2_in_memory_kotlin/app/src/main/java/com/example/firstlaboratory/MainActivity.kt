package com.example.firstlaboratory

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.text.InputType
import android.util.Log
import android.view.animation.AnimationUtils
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import com.example.firstlaboratory.models.TShirt
import com.example.firstlaboratory.service.Service
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.firebase.auth.FirebaseAuth
import kotlinx.android.synthetic.main.activity_main.*
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.auth.api.signin.GoogleSignIn
import androidx.core.app.ComponentActivity.ExtraData
import androidx.core.content.ContextCompat.getSystemService
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import com.google.android.material.textfield.TextInputEditText
import com.google.android.material.textfield.TextInputLayout
import java.security.AccessController.getContext


class MainActivity : AppCompatActivity() {

    private lateinit var tShirtViewModel: TShirtViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        setupUI()

        var adapter = TShirtsAdapter(this)

        recyclerview.layoutManager = LinearLayoutManager(this)
        recyclerview.adapter = adapter


        tShirtViewModel = ViewModelProvider(
            this
        ).get(TShirtViewModel::class.java)
        tShirtViewModel.allTShirts.observe(this, Observer { ts ->
            // Update the cached copy of the words in the adapter.
            ts?.let { adapter.setTShirts(ArrayList(it)) }
        })
        adapter.setViewModel(tShirtViewModel)

        fab.setOnClickListener { showAddDialog() }

        rotate.setOnClickListener {
            val animation = AnimationUtils.loadAnimation(this, R.anim.rotate)
            titleText.startAnimation(animation)
        }

        sync.setOnClickListener{
            if (isNetworkConnected(applicationContext)) {
                GlobalScope.launch {
                    val tsDB: List<TShirt> = Service.repository.getAllStatic()

                    Log.d("SYNC", tsDB.toString())

                    for(t in tsDB){
                        if(t.id < 0){
                            Service.service.insert(t)
                        }
                    }

                    Service.repository.deleteLocals()
                    val tsServer: List<TShirt> = Service.service.getItems()
                    for (tServer in tsServer) {
                        Service.repository.insert(tServer)
                    }
                }
            }
            else{
                Toast.makeText(applicationContext,"Server is down!",Toast.LENGTH_SHORT).show()
            }
        }
    }


//    override fun onCreateOptionsMenu(menu: Menu?): Boolean {
//        menuInflater.inflate(R.menu.buttons, menu)
//        return true
//    }


    fun showAddDialog() {
        val dialogBuilder = AlertDialog.Builder(this)

        val bandLayout = TextInputLayout(this)
        val colorLayout = TextInputLayout(this)
        val sizeLayout = TextInputLayout(this)
        val priceLayout = TextInputLayout(this)
        val currencyLayout = TextInputLayout(this)

        val bandEditText = TextInputEditText(this)
        val colorEditText = TextInputEditText(this)
        val sizeEditText = TextInputEditText(this)
        val priceEditText = TextInputEditText(this)
        val currencyEditText = TextInputEditText(this)
        priceEditText.inputType = InputType.TYPE_CLASS_PHONE

        bandEditText.hint = "Band"
        colorEditText.hint = "Color"
        sizeEditText.hint = "Size"
        priceEditText.hint = "Price"
        currencyEditText.hint = "Currency"

        bandLayout.addView(bandEditText)
        colorLayout.addView(colorEditText)
        sizeLayout.addView(sizeEditText)
        priceLayout.addView(priceEditText)
        currencyLayout.addView(currencyEditText)

        val lp = LinearLayout(this)
        lp.orientation = LinearLayout.VERTICAL

        lp.addView(bandLayout)
        lp.addView(colorLayout)
        lp.addView(sizeLayout)
        lp.addView(priceLayout)
        lp.addView(currencyLayout)

        dialogBuilder.setView(lp)

        dialogBuilder.setTitle("Add TShirt")
        dialogBuilder.setView(lp)

        dialogBuilder.setPositiveButton("Save") { _, _ ->
            if(isNetworkConnected(applicationContext )){
                GlobalScope.launch {
                    val t = Service.service.insert(TShirt(
                        bandEditText.text.toString(),
                        colorEditText.text.toString(),
                        sizeEditText.text.toString(),
                        priceEditText.text.toString().toInt(),
                        currencyEditText.text.toString(),
                        0
                    ))
                    tShirtViewModel.insert(t)
                }

            }
            else{
                GlobalScope.launch {
                    val id = Service.repository.getCount().toLong() * -1
                    tShirtViewModel.insert(
                        TShirt(
                            bandEditText.text.toString(),
                            colorEditText.text.toString(),
                            sizeEditText.text.toString(),
                            priceEditText.text.toString().toInt(),
                            currencyEditText.text.toString(),
                            id
                        ))
                }
            }
        }

        dialogBuilder.setNeutralButton("Cancel") { dialogInterface, _ ->
            dialogInterface.dismiss()
        }

        val b = dialogBuilder.create()
        b.show()
    }

    private fun setupUI() {
        sign_out_button.setOnClickListener {
            signOut()
        }
    }

    private fun signOut() {
        startActivity(SignInActivity.getLaunchIntent(this))
        FirebaseAuth.getInstance().signOut()
        GoogleSignIn.getClient(
            this,
            GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN).build()
        ).signOut()
        finish()
    }

}
